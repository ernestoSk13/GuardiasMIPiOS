//
//  GMCreacionTurnosViewController.swift
//  GuardiasMIP
//
//  Created by Ernesto Sánchez Kuri on 29/06/16.
//  Copyright © 2016 Sankurlabs. All rights reserved.
//

import UIKit
import SuperCoreData.CoreDataHelper

class GMCreacionTurnosViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var txtTurno: UITextField!
    @IBOutlet weak var btnAddTurn: MenuButton!
    @IBOutlet weak var btnDeleteTurn: MenuButton!
    @IBOutlet weak var btnSwap: UIButton!
    var turns = [TurnView!]()
    
    var selectableTurn = TurnView(turnName: "A", order: 1, frame: CGRectZero)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectableTurn.hidden = true

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func loadUI() {
        
    }
    
    func retrieveExistingTurns() {
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addTurn(sender: MenuButton) {
        if txtTurno.text?.characters.count > 0 {
            if validTextfieldInput() == false {
                return
            }
             let lastTurn = turns.last
            var yPosition =  btnAddTurn.frame.origin.y + btnAddTurn.frame.size.height + 15
            var xPosition = (lastTurn != nil) ? CGFloat(lastTurn!.frame.origin.x + lastTurn!.frame.size.width + 20) : CGFloat(20)
            
            if lastTurn != nil && lastTurn!.frame.origin.y >  btnAddTurn.frame.origin.y + btnAddTurn.frame.size.height + 15 {
                yPosition = lastTurn!.frame.origin.y
            }
            
            if (lastTurn != nil && xPosition + lastTurn!.frame.size.width > self.view.frame.size.width) {
                yPosition = CGFloat(lastTurn!.frame.origin.y + lastTurn!.frame.size.height + 20)
                xPosition = CGFloat(20)
            }
            let newTurnView = TurnView(turnName: txtTurno.text! , order: turns.count, frame: CGRectMake(xPosition, yPosition, 60, 60))
            self.view.addSubview(newTurnView)
            let tap = UITapGestureRecognizer(target: self, action: #selector(GMCreacionTurnosViewController.handleTap(_:)))
            newTurnView.addGestureRecognizer(tap)
            
            turns.append(newTurnView)
        }
    }
    
    
    
    func handleTap(sender : UITapGestureRecognizer? =  nil) {
        let senderParent = sender?.view as? TurnView
        if senderParent != nil {
            let lastTurn = turns.last
            let turnName = senderParent!.turnLabel.text!
            let turnOrder = senderParent?.turnOrder
            let height = self.view.frame.size.height - (lastTurn!.frame.origin.y + lastTurn!.frame.size.height) - CGFloat(60)
            let width = height
            let x = self.view.frame.size.width / 2 - CGFloat(width / 2)
            let y = lastTurn!.frame.size.height + lastTurn!.frame.origin.y + CGFloat(50)
            
            if !view.subviews.contains(selectableTurn) {
                selectableTurn = TurnView(turnName: turnName, order: turnOrder!, frame: CGRectMake(x, y, width, height))
                view.addSubview(selectableTurn)
            } else {
                selectableTurn.prepareTurnLabel(turnName)
                selectableTurn.selectOrderColor(turnOrder!)
                selectableTurn.loadUI()
            }
            
            
        }
    }
    
    

    @IBAction func deleteTurn(sender: MenuButton) {
        
    }
    @IBAction func swapTurn(sender: UIButton) {
        
    }
    
    
    //MARK: - Validations
    
    func validTextfieldInput() -> Bool {
        if turns.count > 4 {
            let alert = UIAlertController(title: "Alerta", message: "Por el momento solo se permite un máximo de 5 turnos", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "Ok", style: .Default, handler: { void in
                self.txtTurno.resignFirstResponder()
            })
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
            return false
        }
        
        if txtTurno.text?.characters.count > 1 {
            let alert = UIAlertController(title: "Alerta", message: "Por el momento solo se permite el uso de una sola letra o número para asignar turnos", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "Ok", style: .Default, handler: { void in
                self.txtTurno.resignFirstResponder()
            })
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
