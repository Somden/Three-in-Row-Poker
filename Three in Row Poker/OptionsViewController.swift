//
//  OptionsViewController.swift
//  Three in Row Poker
//
//  Created by Denis Somok on 25.07.15.
//  Copyright (c) 2015 Denis Somok. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {
    
    @IBAction func exitFromOptions() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
