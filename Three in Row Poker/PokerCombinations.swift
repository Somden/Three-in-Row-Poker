//
//  PokerCombinations.swift
//  Three in Row Poker
//
//  Created by Denis Somok on 12.07.15.
//  Copyright (c) 2015 Denis Somok. All rights reserved.
//

import Foundation

class PokerCombinations {
    static func getKnownCombinations() -> [CombinationProtocol] {
        return [
            RoyalFlushCombination(),
            StraightFlushCombination(),
            FourOfAKindCombination(),
            FullHouseCombination(),
            FlushCombination(),
            StraightCombination(),
            ThreeOfAKindCombination(),
            TwoPairCombination(),
            OnePairCombination()
        ]
    }
}
