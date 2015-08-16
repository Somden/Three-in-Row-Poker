//
//  PairCombination.swift
//  Three in Row Poker
//
//  Created by Denis Somok on 12.07.15.
//  Copyright (c) 2015 Denis Somok. All rights reserved.
//

import Foundation

class RoyalFlushCombination : CombinationProtocol {
    var priority: Int {
        return 9
    }
    
    var cardsInCombination: Int {
        return 5
    }
    
    func checkIfCardsMatchCombination(cards: [Card]) -> Bool {
        if cards.count != cardsInCombination { return false }
        
        let straightFlushCombination = StraightFlushCombination()
        
        return straightFlushCombination.checkIfCardsMatchCombination(cards) && checkIfCardsMatchRoyalFlushTypes(cards)
    }
    
    func getPointsForCombination() -> Int {
        return 90
    }
    
    
    
    private func checkIfCardsMatchRoyalFlushTypes(cards: [Card]) -> Bool {
        return cards[0].type == .Ten && cards[1].type == .Jack && cards[2].type == .Queen && cards[3].type == .King && cards[4].type == .Ace ||
        cards[0].type == .Ace && cards[1].type == .King && cards[2].type == .Queen && cards[3].type == .Jack && cards[4].type == .Ten
    }
}

