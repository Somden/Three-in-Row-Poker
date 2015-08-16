//
//  PairCombination.swift
//  Three in Row Poker
//
//  Created by Denis Somok on 12.07.15.
//  Copyright (c) 2015 Denis Somok. All rights reserved.
//

import Foundation

class StraightCombination : CombinationProtocol {
    var priority: Int {
        return 4
    }
    
    var cardsInCombination: Int {
        return 5
    }
    
    func checkIfCardsMatchCombination(cards: [Card]) -> Bool {
        if cards.count != cardsInCombination { return false }
        
        let isGrowingDirection = cards[0].type == cards[1].type.rawValue - 1
        let isDecreasingDirection = cards[0].type == cards[1].type.rawValue + 1
        
        if isGrowingDirection || isDecreasingDirection {
            var delta = isGrowingDirection ? -1 : 1
            
            for var i = 1; i < cardsInCombination - 1; i++ {
                if cards[i].type != cards[i+1].type.rawValue + delta { return false }
            }
            
            return true
        }
        
        return false
    }
    
    func getPointsForCombination() -> Int {
        return 40
    }
}

