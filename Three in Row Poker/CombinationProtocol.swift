//
//  Combination.swift
//  Three in Row Poker
//
//  Created by Denis Somok on 12.07.15.
//  Copyright (c) 2015 Denis Somok. All rights reserved.
//

import Foundation

protocol CombinationProtocol {
    var priority: Int { get }
    var cardsInCombination: Int { get }
    
    func checkIfCardsMatchCombination(cards: [Card]) -> Bool
    func getPointsForCombination() -> Int
}