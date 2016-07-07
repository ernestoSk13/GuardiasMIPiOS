//
//  UIViewExtensions.swift
//  GuardiasMIP
//
//  Created by Ernesto Sánchez Kuri on 02/07/16.
//  Copyright © 2016 Sankurlabs. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func fadeIn () {
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.alpha = 1.0
            }, completion: nil)
    }
    
    func fadeOut () {
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.alpha = 0.0
            }, completion: nil)
    }
    
    func changePosition(to newFrame: CGRect) {
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { 
                self.frame = newFrame
            }) { (completed) in
                
        }
    }
}
