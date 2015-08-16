//
//  RoundedBottomCornersView.swift
//  Three in Row Poker
//
//  Created by Denis Somok on 11.08.15.
//  Copyright (c) 2015 Denis Somok. All rights reserved.
//

import UIKit

class RoundedBottomCornersView: UIView {
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .BottomLeft | .BottomRight, cornerRadii: CGSize(width: 10.0, height: 10.0)).CGPath
        
        self.layer.mask = maskLayer;
    }

}
