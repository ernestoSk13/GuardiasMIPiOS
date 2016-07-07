//
//  TurnView.swift
//  GuardiasMIP
//
//  Created by Ernesto Sánchez Kuri on 29/06/16.
//  Copyright © 2016 Sankurlabs. All rights reserved.
//

import UIKit

class TurnView: UIView {
    let turnLabel = UILabel(frame: CGRectMake(0, 0, 18, 18))
    let colorArray = [UIColor.contrastingRed(), UIColor.contrastingPurple(), UIColor.contrastingGreen(),  UIColor.contrastingOrange(), UIColor.contrastingBlue(), UIColor.contrastingGrey(), UIColor.contrastingGreen(), UIColor.contrastingRed(), UIColor.contrastingOrange()]
    var viewColor = UIColor.greenColor()
    var turnOrder = 0
    var selected = false
    
    init(turnName: String, order: Int, frame: CGRect) {
        super.init(frame: frame)
        self.turnOrder = order
        selectOrderColor(order)
        prepareTurnLabel(turnName)
        loadUI()
    }
    
    
    func prepareTurnLabel(text: String!) {
        turnLabel.frame = CGRectMake( 0, 0, self.frame.width, self.frame.height)
        turnLabel.text = text
        turnLabel.textColor = viewColor
        turnLabel.textAlignment = .Center
        turnLabel.font = UIFont.systemFontOfSize(self.frame.size.height - 5)
        self.addSubview(turnLabel)
    }
    
    func selectOrderColor(order: Int!) {
        self.turnOrder = order
        if (order > (colorArray.count - 1)) {
            self.layer.borderColor = UIColor.greenColor().CGColor
            viewColor = UIColor.greenColor()
        } else {
            self.layer.borderColor = colorArray[order].CGColor
             viewColor = colorArray[order]
        }
       
    }
    
    func loadUI() {
        self.layer.cornerRadius = self.frame.size.height / 2
        //self.layer.borderColor =  UIColor.blackColor().CGColor
        self.userInteractionEnabled = true
        
        self.layer.borderWidth = 1.0
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
