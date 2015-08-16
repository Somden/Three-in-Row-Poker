//
//  GameResultViewController.swift
//  Three in Row Poker
//
//  Created by Denis Somok on 25.07.15.
//  Copyright (c) 2015 Denis Somok. All rights reserved.
//

import UIKit

class GameResultViewController: UIViewController {
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        scoreLabel.text = "\(score)"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
                
            case "showMenu":
                if let uiNavigationController = segue.destinationViewController as? UINavigationController {
                    if let destinationController = uiNavigationController.topViewController as? MenuViewController {
                        destinationController.isGameInProgress = false
                    }
                }
                
            default:
                return
            }
        }
    }
    
    var score: Int = 0 {
        didSet {
            scoreLabel?.text = "\(score)"
        }
    }
    
}
