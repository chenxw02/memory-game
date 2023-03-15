//
//  MemoryGame.swift
//  MemoryGame
//
//  Created by Christopher Chan on 2/22/23.
//

import Foundation

struct GameModel{
    private(set) var cards: Array<Card>
    // use content to build cards
    private(set) var content: String
    private(set) var matchedCount: Int
    private(set) var score: Double
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter({cards[$0].isFaceUp}).oneAndOnly}
        set { cards.indices.forEach{cards[$0].isFaceUp = ($0 == newValue)}}
    }
    
    mutating func choose(_ card: Card){
        // chosen card not face-up and not matched
        if let chosenIndex = cards.firstIndex(where: {$0.id == card.id}),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched
        {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                // find a match
                if cards[chosenIndex].content == cards[potentialMatchIndex].content{
                    // set as matched
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    // calculating scores
                    if cards[chosenIndex].hasEarnedBonus && cards[potentialMatchIndex].hasEarnedBonus {
                        // base score * average bonus remaining (in percentage)
                        score += 10*(cards[chosenIndex].bonusRemaining+cards[potentialMatchIndex].bonusRemaining)/2
                    }
                }
                cards[chosenIndex].isFaceUp = true
            } else {
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
        }
        checkGame()
    }
    
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    mutating func checkGame() {
        matchedCount = 0
        for card in cards {
            if card.isMatched {
                matchedCount += 1
            }
        }
    }
    
    mutating func setCards(message: String) {
        // store the message for newGame()
        content = message
        cards.removeAll()
        let messageArray = Array(message)
        for pairIndex in 0..<messageArray.count {
            cards.append(Card(content: String(messageArray[pairIndex]), id: pairIndex*2))
            cards.append(Card(content: String(messageArray[pairIndex]), id: pairIndex*2+1))
        }
        shuffle()
    }
    
    mutating func newGame() {
        // set cards once again
        setCards(message: content)
        score = 0
    }
    
    init(){
        cards = []
        content = ""
        matchedCount = 0
        score = 0
    }
    
    struct Card: Identifiable {
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        let content: String
        let id: Int
        
        // the following codes in this strcut are directly from Stanford 193p
        
        var bonusTimeLimit: TimeInterval = 6
        
        // how long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        // the last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        // the accumulated time this card has been face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0
        
        // how much time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        // percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        // whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        // whether we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
}

extension Array {
    var oneAndOnly: Element? {
        if count == 1 {
            return first
        } else {
            return nil
        }
    }
}

extension Array{
    mutating func shuffle(){
        for i in 0..<(count-1){
            let j = Int(arc4random_uniform(UInt32(count-i)))+i
            if i != j{
                self.swapAt(i, j)
            }
        }
    }
}

extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

