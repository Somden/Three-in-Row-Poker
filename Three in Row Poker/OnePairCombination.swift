//
//  PairCombination.swift
//  Three in Row Poker
//
//  Created by Denis Somok on 12.07.15.
//  Copyright (c) 2015 Denis Somok. All rights reserved.
//

import Foundation

class OnePairCombination : CombinationProtocol {
    var priority: Int {
        return 1
    }
    
    var cardsInCombination: Int {
        return 2
    }
    
    func checkIfCardsMatchCombination(cards: [Card]) -> Bool {
        if cards.count != cardsInCombination { return false }
        
        return cards[0].type == cards[1].type
    }
    
    func getPointsForCombination() -> Int {
        return 10
    }
}