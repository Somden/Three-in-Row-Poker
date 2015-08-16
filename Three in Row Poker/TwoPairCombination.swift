//
//  PairCombination.swift
//  Three in Row Poker
//
//  Created by Denis Somok on 12.07.15.
//  Copyright (c) 2015 Denis Somok. All rights reserved.
//

import Foundation

class TwoPairCombination : CombinationProtocol {
    var priority: Int {
        return 2
    }
    
    var cardsInCombination: Int {
        return 4
    }
    
    func checkIfCardsMatchCombination(cards: [Card]) -> Bool {
        if cards.count != cardsInCombination { return false }
        
        return cards[0].type == cards[1].type && cards[2].type == cards[3].type
    }
    
    func getPointsForCombination() -> Int {
        return 20
    }
}