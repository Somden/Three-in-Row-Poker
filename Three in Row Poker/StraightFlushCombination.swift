//
//  PairCombination.swift
//  Three in Row Poker
//
//  Created by Denis Somok on 12.07.15.
//  Copyright (c) 2015 Denis Somok. All rights reserved.
//

import Foundation

class StraightFlushCombination : CombinationProtocol {
    var priority: Int {
        return 8
    }
    
    var cardsInCombination: Int {
        return 5
    }
    
    func checkIfCardsMatchCombination(cards: [Card]) -> Bool {
        if cards.count != cardsInCombination { return false }
        
        let straightCombination = StraightCombination()
        let flushCombination = FlushCombination()
        
        return straightCombination.checkIfCardsMatchCombination(cards) &&
            flushCombination.checkIfCardsMatchCombination(cards)
    }
    
    func getPointsForCombination() -> Int {
        return 80
    }
}

