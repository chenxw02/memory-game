//
//  GameViewModel.swift
//  MemoryGame
//
//  Created by Christopher Chan on 2/22/23.
//

import SwiftUI

class GameViewModel: ObservableObject {
    typealias Card = GameModel.Card
  
    @Published private(set) var model = GameModel()
    
    // MARK -variables
    var cards: Array<Card> {
        model.cards
    }
    
    var matchedCount: Int {
        model.matchedCount
    }
    
    var score: String {
        String(format: "%.2f", model.score)
    }
    
    // MARK -intents
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func newGame() {
        model.newGame()
    }
    
    func setCards(message: String){
        model.setCards(message: message)
    }
    
}


