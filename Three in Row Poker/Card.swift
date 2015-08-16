//
//  Card.swift
//  Three in Row Poker
//
//  Created by Denis Somok on 09.07.15.
//  Copyright (c) 2015 Denis Somok. All rights reserved.
//

import Foundation
import SpriteKit


let NumberOfCardTypes: UInt32 = 13
let NumberOfSuits: UInt32 = 4

enum CardType: Int, Printable {
    
    case Two = 2, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King, Ace
    
    var description: String {
        switch self {
        case .Two: return "2"
        case .Three: return "3"
        case .Four: return "4"
        case .Five: return "5"
        case .Six: return "6"
        case .Seven: return "7"
        case .Eight: return "8"
        case .Nine: return "9"
        case .Ten: return "10"
        case .Jack: return "J"
        case .Queen: return "Q"
        case .King: return "K"
        case .Ace: return "A"
        }
    }
    
    static func getRandom() -> CardType {
        return CardType(rawValue: Int(arc4random_uniform(NumberOfCardTypes)) + 2)!
    }
}

func == (left: CardType, right: Int) -> Bool {
    if left == .Ace && right == 1 { return true }
    
    return left.rawValue == right
}

func != (left: CardType, right: Int) -> Bool {
    return !(left == right)
}



enum CardSuit: Int, Printable {
    case Spade = 0, Club, Diamond, Heart
    
    
    var description: String {
        switch self {
        case .Spade: return "♠︎"
        case .Club: return "♣︎"
        case .Diamond: return "♦︎"
        case .Heart: return "♥︎"
        }
    }
    
    var nameForSprite: String {
        switch self {
        case .Spade: return "spades"
        case .Club: return "clubs"
        case .Diamond: return "diamonds"
        case .Heart: return "hearts"
        }
    }
    
    static func getRandom() -> CardSuit {
        return CardSuit(rawValue: Int(arc4random_uniform(NumberOfSuits)))!
    }
}



class Card: Printable, Hashable {
    var type: CardType
    var suit: CardSuit
    
    var column: Int
    var row: Int
    
    var sprite: SKSpriteNode?
    
    init(type: CardType, suit: CardSuit, column: Int, row: Int) {
        self.type = type
        self.suit = suit
        self.column = column
        self.row = row
    }
    
    convenience init(type: CardType, suit: CardSuit) {
        self.init(type: type, suit: suit, column: 0, row: 0)
    }
    
    
    var description: String {
        return "\(self.type)\(self.suit)"
    }
    
    var hashValue: Int {
        return "\(self.column),\(self.row)".hashValue
    }
    
    
    var spriteName: String {
        return "\(self.type)-\(self.suit.nameForSprite)"
    }
    
    func moveToNewPosition(#row: Int, column: Int) {
        self.row = row
        self.column = column
    }
    
    
    static func createRandom() -> Card {
        return Card(type: CardType.getRandom(), suit: CardSuit.getRandom())
    }
    
    static func createRandom(#column: Int, row: Int) -> Card {
        return Card(type: CardType.getRandom(), suit: CardSuit.getRandom(), column: column, row: row)
    }
    
    static func getAllCards() -> [Card] {
        var deck = [Card]()
        
        for suit in 0..<NumberOfSuits {
            for type in 2..<NumberOfCardTypes + 2 {
                var cardType = CardType(rawValue: Int(type))!
                var cardSuit = CardSuit(rawValue: Int(suit))!
                deck.append(Card(type: cardType, suit: cardSuit))
            }
        }
        
        return deck
    }
}

func == (left: Card, right: Card) -> Bool {
    return left.row == right.row && left.column == right.column
}
