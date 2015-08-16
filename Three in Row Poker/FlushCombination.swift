//
//  PairCombination.swift
//  Three in Row Poker
//
//  Created by Denis Somok on 12.07.15.
//  Copyright (c) 2015 Denis Somok. All rights reserved.
//

import Foundation

class FlushCombination : CombinationProtocol {
    var priority: Int {
        return 5
    }
    
    var cardsInCombination: Int {
        return 5
    }
    
    func checkIfCardsMatchCombination(cards: [Card]) -> Bool {
        if cards.count != cardsInCombination { return false }
        
        return cards.filter({$0.suit == cards[0].suit}).count == cardsInCombination
    }
    
    func getPointsForCombination() -> Int {
        return 50
    }
}

