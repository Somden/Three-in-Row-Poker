//
//  PairCombination.swift
//  Three in Row Poker
//
//  Created by Denis Somok on 12.07.15.
//  Copyright (c) 2015 Denis Somok. All rights reserved.
//

import Foundation

class FullHouseCombination : CombinationProtocol {
    var priority: Int {
        return 6
    }
    
    var cardsInCombination: Int {
        return 5
    }
    
    func checkIfCardsMatchCombination(cards: [Card]) -> Bool {
        if cards.count != cardsInCombination { return false }
        
        return cards[0].type == cards[1].type && cards[2].type == cards[3].type && cards[3].type == cards[4].type ||
            cards[0].type == cards[1].type && cards[1].type == cards[2].type && cards[3].type == cards[4].type
    }
    
    func getPointsForCombination() -> Int {
        return 60
    }
}

