//
//  Game.swift
//  Three in Row Poker
//
//  Created by Denis Somok on 09.07.15.
//  Copyright (c) 2015 Denis Somok. All rights reserved.
//

import Foundation

protocol GameDelegate {
    func gameBegun(game: Game)
    func cardChanged(game: Game, oldCard: Card, newCard: Card)
    func cardsSwapped(game: Game, card1: Card, card2: Card)
    func cardsRemoved(game: Game, removedCards: [Card], fallenCards: [Card], newCards: [Card])
    func scoreChanged(game: Game)
    func comboChanged(game: Game)
    func movesLeftChanged(game: Game)
    func gameEnd(game: Game)
}

class Game {
    static let NumOfColumns = 6
    static let NumOfRows = 6
    static let NumOfMoves = 1
    
    private var array: Array2D<Card>
    var cards: [Card?] {
        return array.toFlatArray()
    }
    
    var score: Int = 0 {
        didSet {
            delegate?.scoreChanged(self)
        }
    }
    var combo: Int = 1 {
        didSet {
            delegate?.comboChanged(self)
        }
    }
    var movesLeft = Game.NumOfMoves {
        didSet {
            delegate?.movesLeftChanged(self)
        }
    }
    
    var delegate: GameDelegate?
    
    init() {
        self.array = Array2D<Card>(columns: Game.NumOfColumns, rows: Game.NumOfRows)
    }
    
    func beginGame() {
        self.resetGame()
        self.fillEmptyFields()
        
        if delegate != nil {
            delegate?.gameBegun(self)
        }
    }
    
    func resetGame() {
        for row in 0..<Game.NumOfRows {
            for column in 0..<Game.NumOfColumns {
                self.array[row, column] = nil
            }
        }
        
        self.score = 0
        self.combo = 1
        self.movesLeft = Game.NumOfMoves
    }
    
    
    
    func getCard(#row: Int, column: Int) -> Card? {
        if row < 0 || row >= Game.NumOfRows || column < 0 || column >= Game.NumOfColumns {
            return nil
        }
        
        return self.array[row, column]
    }
    
    func changeCard(oldCard: Card, newCard: Card) {
        newCard.row = oldCard.row
        newCard.column = oldCard.column
        self.array[oldCard.row, oldCard.column] = newCard
        
        self.delegate?.cardChanged(self, oldCard: oldCard, newCard: newCard)
    }
    
    func swapCards(card1: Card, _ card2: Card) {
        if  movesLeft > 0 &&
            card1.row == card2.row && (abs(card1.column - card2.column) == 1) ||
            card1.column == card2.column && (abs(card1.row - card2.row) == 1) {
                var card2Position = (row: card2.row, column: card2.column)
                card2.moveToNewPosition(row: card1.row, column: card1.column)
                card1.moveToNewPosition(row: card2Position.row, column: card2Position.column)
                
                self.array[card1.row, card1.column] = card1
                self.array[card2.row, card2.column] = card2
                
                delegate?.cardsSwapped(self, card1: card1, card2: card2)
                
                movesLeft--
        }
    }
    
    func removeCombinations() -> [Card] {
        var combinations = findCombinations()
        if combinations.count > 0 {
            self.score = combinations.reduce(self.score) {
                return $0 + self.combo * $1.combination.getPointsForCombination()
            }
            
            var removedCards = combinations.reduce([], combine:{ (cards, combination) -> [Card] in
                var newArray = cards
                newArray += combination.cards
                return newArray
            })
            
            let uniqueRemovedCards = Array<Card>(Set<Card>(removedCards))
            
            for card in uniqueRemovedCards {
                self.array[card.row, card.column] = nil
            }
            
            // var fallenCards = self.letCardsFallToEmptySpaces()
            var newCards = self.fillEmptyFields()
            
            self.combo++
            
            delegate?.cardsRemoved(self, removedCards: uniqueRemovedCards, fallenCards: [], newCards: newCards)
            
            return uniqueRemovedCards
        } else {
            self.combo = 1
        }
        
        return []
    }
    
    func checkIfGameEnded() -> Bool {
        if movesLeft == 0 {
            delegate?.gameEnd(self)
            return true
        }
        
        return false
    }
    
    
    
    // MARK: - Cards manangement logic
    
    private func fillEmptyFields() -> [Card] {
        var result: [Card] = []
        for row in 0..<Game.NumOfRows {
            for column in 0..<Game.NumOfColumns {
                if self.array[row, column] == nil {
                    var newCard = Card.createRandom(column: column, row: row)
                    self.array[row, column] = newCard
                    result.append(newCard)
                }
            }
        }
        
        return result
    }
    
    
    // MARK: - Combinations detecting logic
    
    private func findCombinations() -> [(cards: [Card], combination: CombinationProtocol)] {
        let combinations = PokerCombinations.getKnownCombinations()
        var result: [(cards: [Card], combination: CombinationProtocol)] = []
        
        for row in 0..<Game.NumOfRows {
            for column in 0..<Game.NumOfColumns {
                if let card = self.array[row, column] {
                    for combination in combinations {
                        let checkCardResult = self.checkCardForCombination(card, combination: combination)
                        if checkCardResult.isMatch {
                            result.append((cards: checkCardResult.cards!, combination: combination))
                        }
                    }
                }
            }
        }
        
        return result
    }
    
    private func grabCardsForCardFromSameRow(card: Card, count: Int) -> [Card]? {
        if count <= Game.NumOfColumns - card.column {
            var result = [card]
            for var i = 1; i < count; i++ {
                result.append(self.array[card.row, card.column + i]!)
            }
            
            return result
        }
        
        return nil
    }
    
    private func grabCardsForCardFromSameColumn(card: Card, count: Int) -> [Card]? {
        if count <= Game.NumOfRows - card.row {
            var result = [card]
            for var i = 1; i < count; i++ {
                result.append(self.array[card.row + i, card.column]!)
            }
            
            return result
        }
        
        return nil
    }
    
    private func checkCardForCombination(card: Card, combination: CombinationProtocol) -> (isMatch: Bool, cards: [Card]?) {
        if let cards = self.grabCardsForCardFromSameRow(card, count: combination.cardsInCombination) {
            if combination.checkIfCardsMatchCombination(cards) {
                return (isMatch: true, cards: cards)
            }
        }
        
        if let cards = self.grabCardsForCardFromSameColumn(card, count: combination.cardsInCombination) {
            if combination.checkIfCardsMatchCombination(cards) {
                return (isMatch: true, cards: cards)
            }
        }
        
        return (isMatch: false, cards: nil)
    }
    
    
    
    private func letCardsFallToEmptySpaces() -> [Card] {
        var fallenCards = [Card]()
        for row in 1..<Game.NumOfRows {
            for column in 0..<Game.NumOfColumns {
                if let card = self.array[row, column] {
                    var newRow = card.row - 1
                    
                    if self.array[newRow, column] == nil {
                        do {
                            newRow--
                        } while newRow >= 0 && self.array[newRow, column] == nil
                        
                        self.array[card.row, card.column] = nil
                        card.row = newRow + 1
                        self.array[card.row, card.column] = card
                        fallenCards.append(card)
                    }
                }
            }
        }
        
        return fallenCards
    }
}