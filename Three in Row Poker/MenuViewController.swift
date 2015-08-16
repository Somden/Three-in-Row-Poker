//
//  MenuViewController.swift
//  Three in Row Poker
//
//  Created by Denis Somok on 09.07.15.
//  Copyright (c) 2015 Denis Somok. All rights reserved.
//

import UIKit
import SpriteKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var continueButton: UIButton!
    
    var isGameInProgress = true {
        didSet {
            continueButton?.hidden = !isGameInProgress
        }
    }
    
    @IBAction func continueGame() {
        navigationController?.dismissViewControllerAnimated(true) { }
    }
    
    override func viewDidLoad() {
        continueButton.hidden = !isGameInProgress
    }
}