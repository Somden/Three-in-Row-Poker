//
//  GameViewController.swift
//  Three in Row Poker
//
//  Created by Denis Somok on 09.07.15.
//  Copyright (c) 2015 Denis Somok. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, GameDelegate, UIPopoverPresentationControllerDelegate {
    var game: Game!
    var scene: GameScene!
    
    var isInJokerMode = false
    var cardSelectedToExchangeInJokerMode: Card? = nil
    
    
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var movesLabel: UILabel!
    
    
    
    private struct Segues {
        static let showResults = "showResults"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = view as! SKView
        skView.multipleTouchEnabled = false
        
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        
        game = Game()
        game.delegate = self
        game.beginGame()
        
        skView.presentScene(scene)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Segues.showResults:
                if let uiNavController = segue.destinationViewController as? UINavigationController {
                    if let destinationController = uiNavController.topViewController as? GameResultViewController {
                        destinationController.score = self.game.score
                    }
                }
            default: return
            }
        }
    }
    
    
    @IBAction func startNewGame(segue: UIStoryboardSegue) {
        if game != nil {
            scene?.resetScene(game.cards)
            game.beginGame()
        }
    }
    
    @IBAction func didSwipe(sender: UISwipeGestureRecognizer) {
        if !isInJokerMode {
            var  location = sender.locationInView(self.view)
            // Change to coordinates from left bottom
            location.y = self.view.bounds.size.height - location.y
            let position = scene.positionForPoint(location)
            
            if let card = game.getCard(row: position.row, column: position.column) {
                switch sender.direction {
                case UISwipeGestureRecognizerDirection.Up:
                    if let upperCard = game.getCard(row: position.row + 1, column: position.column) {
                        game.swapCards(card, upperCard)
                    }
                case UISwipeGestureRecognizerDirection.Down:
                    if let lowerCard = game.getCard(row: position.row - 1, column: position.column) {
                        game.swapCards(card, lowerCard)
                    }
                case UISwipeGestureRecognizerDirection.Left:
                    if let leftCard = game.getCard(row: position.row, column: position.column - 1) {
                        game.swapCards(card, leftCard)
                    }
                case UISwipeGestureRecognizerDirection.Right:
                    if let rightCard = game.getCard(row: position.row, column: position.column + 1) {
                        game.swapCards(card, rightCard)
                    }
                default: return
                }
            }
        }
    }
    
    
    @IBAction func didTap(sender: UITapGestureRecognizer) {
        if isInJokerMode {
            var location = sender.locationInView(self.view)
            // Change to coordinates from left bottom
            location.y = self.view.bounds.size.height - location.y
            let position = scene.positionForPoint(location)
            
            if let card = game.getCard(row: position.row, column: position.column) {
                self.cardSelectedToExchangeInJokerMode = card
                showJokerView()
            }
        }
    }
    
    
    @IBAction func useJoker() {
        self.isInJokerMode = true
    }
    
    
    @IBAction func hideJokerView(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let jokerVC = segue.sourceViewController as? JokerViewController {
            self.game.changeCard(self.cardSelectedToExchangeInJokerMode!, newCard: jokerVC.selectedCard!)
            self.cardSelectedToExchangeInJokerMode = nil
            self.isInJokerMode = false
        }
    }
    
    private func showJokerView() {
        
        var jokerVC = self.storyboard?.instantiateViewControllerWithIdentifier("JokerViewController") as! JokerViewController
        jokerVC.modalPresentationStyle = UIModalPresentationStyle.Popover
        jokerVC.preferredContentSize = CGSizeMake(self.view.bounds.size.width, 100)
        if let popover = jokerVC.popoverPresentationController {
            popover.permittedArrowDirections = UIPopoverArrowDirection.allZeros
            popover.sourceView = self.view
            popover.sourceRect = CGRectMake(0, self.view.bounds.height/2, 0, 0)
            popover.delegate = self // to force no adaptive
            self.presentViewController(jokerVC, animated: true, completion: nil)
        }
    }
    
    // MARK: - GameDelegate implementation
    
    func gameBegun(game: Game) {
        scene.showCards(game.cards) {}
    }
    
    func cardChanged(game: Game, oldCard: Card, newCard: Card) {
        self.scene.changeCard(oldCard: oldCard, newCard: newCard) {}
    }
    
    func cardsSwapped(game: Game, card1: Card, card2: Card) {
        self.view.userInteractionEnabled = false
        self.scene.swapCards(card1, card2) {
            if game.removeCombinations().count == 0 {
                game.checkIfGameEnded()
            }
            
            self.view.userInteractionEnabled = true
        }
    }
    
    func cardsRemoved(game: Game, removedCards: [Card], fallenCards: [Card], newCards: [Card]) {
        self.view.userInteractionEnabled = false
        self.scene.removeCards(removedCards) {
            // self.scene.fallCards(fallenCards) {
            
            self.scene.showCards(newCards) {
                if game.removeCombinations().count == 0 {
                    game.checkIfGameEnded()
                    self.view.userInteractionEnabled = true
                }
            }
            
            // }
        }
    }
    
    func scoreChanged(game: Game) {
        self.scoreLabel.text = "\(game.score)"
    }
    
    func comboChanged(game: Game) {
        if game.combo > 2 {
            self.scene.showCombo(game.combo - 1)
        }
    }
    
    func movesLeftChanged(game: Game) {
        self.movesLabel.text = "\(game.movesLeft)"
    }
    
    func gameEnd(game: Game) {
        performSegueWithIdentifier(Segues.showResults, sender: self)
    }
    
    
    
    // MARK: - UIPopoverPresentationControllerDelegate implementation
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
}
