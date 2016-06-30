//
//  TurnView.swift
//  GuardiasMIP
//
//  Created by Ernesto Sánchez Kuri on 29/06/16.
//  Copyright © 2016 Sankurlabs. All rights reserved.
//

import UIKit

class TurnView: UIView {
    let turnLabel = UILabel(frame: CGRectMake(0, 0, 20, 20))
    let colorArray = [UIColor.redColor(), UIColor.yellowColor(), UIColor.greenColor(),  UIColor.orangeColor(), UIColor.magentaColor(), UIColor.brownColor(),  UIColor.blueColor(), UIColor.grayColor(), UIColor.cyanColor(),UIColor.purpleColor()]
    var viewColor = UIColor.greenColor()
    var turnOrder = 0
    
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
        turnLabel.textColor = UIColor.blackColor()
        turnLabel.textAlignment = .Center
        turnLabel.font = UIFont.systemFontOfSize(self.frame.size.height)
        self.addSubview(turnLabel)
    }
    
    func selectOrderColor(order: Int!) {
        self.turnOrder = order
        if (order > (colorArray.count - 1)) {
            self.backgroundColor = .greenColor()
        } else {
            self.backgroundColor = colorArray[order]
        }
        viewColor = self.backgroundColor!
    }
    
    func loadUI() {
        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.borderColor =  UIColor.blackColor().CGColor
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
