//
//  GameView.swift
//  MemoryGame
//
//  Created by Christopher Chan on 2/21/23.
//

import SwiftUI
import CoreGraphics

struct GameView: View {
    @ObservedObject var game = GameViewModel()
    @Environment(\.dismiss) var dismissSheet
    @State var gameColor: Color = .orange
    
    // this var contains a string of emojis, we use it to build our cards
    var message: String
    var count: Int
    var body: some View {
        
        VStack(){
            gameBody.padding(.horizontal)
            HStack {
                shuffle
                Spacer(minLength: 0)
                newGame
            }
            .padding(.horizontal)
            .onAppear {
                // before gamebody appears, build our cards
                game.setCards(message: message)
                // choose a random color for our cards
                gameColor = colors.randomElement() ?? .orange
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title:Text("You win!"),
                message: Text("Your total score is: \(game.score) "),
                // go back to home
                primaryButton: .destructive(Text("Go Back")){
                    isAllMatched.toggle()
                    dismissSheet()
                },
                // start a new game
                secondaryButton: .default(Text("New Game")) {
                    isAllMatched.toggle()
                    game.newGame()
                }
            )
        }.padding(0)
        
    }
    
    @State var showAlert: Bool = false
    @State public var matchedCount: Int = 0
    @State var isAllMatched: Bool = false
    
    let colors: [Color] = [.green, .red, .orange, .blue,]
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
            // card is matched or not face-up
            if card.isMatched && !card.isFaceUp || isAllMatched {
                Color.clear
            } else {
                CardView(card: card)
                    .padding(4)
                    .transition(AnyTransition.scale.animation(Animation.easeInOut))
                    .onTapGesture{
                        withAnimation{
                            game.choose(card)
                        }
                        matchedCount = game.matchedCount
                        if matchedCount == count {
                            showAlert = true
                            isAllMatched = true
                        }
                    }
            }
        }
        .foregroundColor(gameColor)
    }
    
    // shuffle button
    var shuffle: some View {
        Button("Shuffle") {
            withAnimation {
                game.shuffle()
            }
        }
    }
    
    // new-game button
    var newGame: some View {
        Button("New Game") {
            withAnimation {
                game.newGame()
                game.shuffle()
            }
        }
    }
}

struct CardView: View {
    let card: GameViewModel.Card
    @State private var animatedBonusRemaining: Double = 1
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                Group {
                    if !card.isMatched && card.isConsumingBonusTime {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-animatedBonusRemaining)*360-90))
                            .onAppear {
                                // animation takes place when this card appears
                                // animate bonusRemaining from 1 to 0
                                animatedBonusRemaining = card.bonusRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                    animatedBonusRemaining = 0
                                }
                            }
                    } else {
                        // for all matched cards: clear the pie shape
                        Color.clear
                    }
                }
                .padding(8)
                .opacity(0.4)
                
                Text(card.content)
                    // when macthed, emoji rotates
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .font(Font.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
            }.cardify(isFaceUp: card.isFaceUp)
        }
    }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let fontScale: CGFloat = 0.6
        static let fontSize: CGFloat = 32
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = GameViewModel()
        return GameView(game: game, message: "🍎🤓😆😆", count: 8)
    }
}

