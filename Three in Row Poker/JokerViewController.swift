//
//  JokerViewController.swift
//  Three in Row Poker
//
//  Created by Denis Somok on 03.08.15.
//  Copyright (c) 2015 Denis Somok. All rights reserved.
//

import UIKit

class JokerViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    private let CardHeight = 100
    private let CardWidth = 65
    private let CardMargin = 5
    
    private var FullCardWidth: Int {
        return CardWidth + 2 * CardMargin
    }
    
    let allCards = Card.getAllCards()
    var selectedCard: Card? = nil
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func didTap(sender: UITapGestureRecognizer) {
        let location = sender.locationInView(self.scrollView)
        let cardIndex = Int(location.x / CGFloat(FullCardWidth))
        self.selectedCard = self.allCards[cardIndex]
        
        self.performSegueWithIdentifier("hideJokerView", sender: self)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.superview!.layer.cornerRadius = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for (index, card) in enumerate(allCards) {
            drawCard(card, index: index)
        }
        
        scrollView.contentSize = CGSize(width: allCards.count * FullCardWidth, height: CardHeight)
    }
    
    func popoverPresentationControllerShouldDismissPopover(popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return false
    }
    
    
    
    private func drawCard(card: Card, index: Int) {
        var view = UIView(frame: CGRect(x: index * FullCardWidth, y: 1, width: CardWidth, height: CardHeight))
        
        var imageView = UIImageView(frame: CGRect(x: CardMargin, y: 0, width: CardWidth, height: CardHeight))
        var image = UIImage(named: card.spriteName)
        imageView.image = image
        
        view.addSubview(imageView)
        scrollView.addSubview(view)
    }
}
