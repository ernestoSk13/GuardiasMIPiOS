//
//  MenuButton.swift
//  GuardiasMIP
//
//  Created by Ernesto Sánchez Kuri on 28/06/16.
//  Copyright © 2016 Sankurlabs. All rights reserved.
//

import UIKit

public class MenuButton: UIButton {
    public var roundRectCornerRadius :CGFloat = 8 {
        didSet {
            self.setNeedsLayout()
        }
    }
   
    public var roundRectColor: UIColor = UIColor.whiteColor() {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    // MARK: Overrides
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        layoutRoundRectLayer()
    }
    
    // MARK: Private
    
    private var roundRectLayer: CAShapeLayer?
    
    private func layoutRoundRectLayer() {
        if let existingLayer = roundRectLayer {
            existingLayer.removeFromSuperlayer()
        }
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: roundRectCornerRadius).CGPath
        self.layer.borderColor = UIColor(red: 75.0/255.0, green: 201.0/255.0, blue: 230.0/255.0, alpha: 1.0).CGColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 10
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        self.layer.insertSublayer(shapeLayer, atIndex: 0)
        self.roundRectLayer = shapeLayer
    }
    
}
