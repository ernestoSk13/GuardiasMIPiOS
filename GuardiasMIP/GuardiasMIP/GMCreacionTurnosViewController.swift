//
//  GMCreacionTurnosViewController.swift
//  GuardiasMIP
//
//  Created by Ernesto Sánchez Kuri on 29/06/16.
//  Copyright © 2016 Sankurlabs. All rights reserved.
//

import UIKit
//import SuperCoreData.CoreDataHelper


class GMCreacionTurnosViewController: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {

    @IBOutlet weak var txtTurno: UITextField!
    @IBOutlet weak var btnAddTurn: MenuButton!
    @IBOutlet weak var btnDeleteTurn: MenuButton!
    var sharedHelper =  (UIApplication.sharedApplication().delegate as! AppDelegate)._coreDataHelper
    var turns = [TurnView!]()
    var turnObjects = [Turno!]()
    var selectedTurn : Turno?
    var hasSelectedTurn = false
    var hasLaunchedScreen = false
    
    @IBOutlet weak var btnNext: UIBarButtonItem!
    
    var selectableTurn = TurnView(turnName: "A", order: 1, frame: CGRectZero)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnNext.action = #selector(GMCreacionTurnosViewController.validateAndAvance)
        btnNext.target = self
         loadUI()
        

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        retrieveExistingTurns()
    }
    
    func loadUI() {
         btnDeleteTurn.alpha = 0.0
        selectableTurn.hidden = true
        selectableTurn.alpha = 0.0
        txtTurno.delegate = self
        let gesture = UITapGestureRecognizer(target: self, action: #selector(GMCreacionTurnosViewController.resignTextField))
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(gesture)
    }
    
    func resignTextField() {
        self.txtTurno.resignFirstResponder()
    }
    
    func retrieveExistingTurns() {
        turnObjects = self.sharedHelper.savedObjectInstanceFromObjectWithName("Turno", onDatabaseWithConditions: nil) as! [Turno!]
        if turnObjects.count > 0 {
            turns.removeAll(keepCapacity: false)
            //placeExistingTurns()
        }
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: -Core Data Methods
    
    @IBAction func addTurn(sender: MenuButton) {
        if txtTurno.text?.characters.count > 0 {
            if validTextfieldInput() == false {
                return
            }
            let isNew = true
            if isNew {
                let lastTurn = turns.last
                var yPosition =  txtTurno.frame.origin.y + txtTurno.frame.size.height + 15
                var xPosition = (lastTurn != nil) ? CGFloat(lastTurn!.frame.origin.x + lastTurn!.frame.size.width + 20) : CGFloat(20)
                
                if lastTurn != nil && lastTurn!.frame.origin.y >  txtTurno.frame.origin.y + txtTurno.frame.size.height + 15 {
                    yPosition = lastTurn!.frame.origin.y
                }
                
                if (lastTurn != nil && xPosition + lastTurn!.frame.size.width > self.view.frame.size.width) {
                    yPosition = CGFloat(lastTurn!.frame.origin.y + lastTurn!.frame.size.height + 20)
                    xPosition = CGFloat(20)
                }
                let initialFrame = CGRectMake(self.view.frame.width, yPosition, 0, 40)
                let lastFrame = CGRectMake(xPosition, yPosition, 40, 40)
                
                let newTurnView = TurnView(turnName: txtTurno.text! , order: turns.count, frame: initialFrame)
                UIView.animateWithDuration(1.0, delay: 0.5, options: [.CurveEaseInOut], animations: { 
                        newTurnView.frame = lastFrame
                    }, completion: nil)
                
                self.view.addSubview(newTurnView)
                let tap = UITapGestureRecognizer(target: self, action: #selector(GMCreacionTurnosViewController.handleTap(_:)))
                newTurnView.addGestureRecognizer(tap)
                if let currentTurn = newTurn(newTurnView) {
                    sharedHelper.setNewInstanceFromObjectWithName("Turno", usingParams: currentTurn, withMainIdentifier: "idTurno", withSuccess: { (success) in
                            self.txtTurno.text = ""
                            self.txtTurno.resignFirstResponder()
                            self.turnObjects =  self.sharedHelper.savedObjectInstanceFromObjectWithName("Turno", onDatabaseWithConditions: nil) as! [Turno!]
                        }, orError: { (errorStr, errorDict) in
                            
                    })
                    turns.append(newTurnView)
                }
                
            } else {
                
//                if let currentTurn = newTurn(selectableTurn) {
//                    sharedHelper.updateExistingInstanceFromObjectWithName("Turno", usingParams: currentTurn, withMainIdentifier: "idTurno", withSuccess: { (success) in
//                        self.selectableTurn.prepareTurnLabel(self.txtTurno.text!)
//                        }, orError: { (errorString, errorDict) in
//                            
//                    })
//                }
                
            }
            
            
        }
    }
    
    
    func newTurn(_turnView : TurnView) -> [String : String]? {
        
        let turn = [    "idTurno": txtTurno.text!,
                        "nombreTurno" : txtTurno.text!,
                        "inicioTurno" : "",
                        "finTurno"    : "",
                        "colorTurno"  : _turnView.viewColor.description,
                        "ordenTurno"  : "\(_turnView.turnOrder)"
                        ]
        return turn
        
    }
    
    
    
    
    func handleTap(sender : UITapGestureRecognizer? =  nil) {
        let senderParent = sender?.view as? TurnView
        if senderParent != nil {
            if senderParent?.selected == false {
                let lastTurn = turns.last
                let turnName = senderParent!.turnLabel.text!
                let turnOrder = senderParent?.turnOrder
                let btnDeleteFrame =  btnDeleteTurn.frame.size.height + 20
                let height = self.view.frame.size.height - (lastTurn!.frame.origin.y + lastTurn!.frame.size.height) -  btnDeleteFrame - btnDeleteFrame * 0.5
                let width = height
                let x = self.view.frame.size.width / 2 - CGFloat(width / 2)
                let y = lastTurn!.frame.size.height + lastTurn!.frame.origin.y + CGFloat(15)
                selectableTurn.hidden = false
                //selectedTurn = turnObjects[1]
                if let index = turnObjects.indexOf({$0.idTurno == turnName}) {
                    selectedTurn = turnObjects[index]
                }
                if !view.subviews.contains(selectableTurn) {
                    selectableTurn = TurnView(turnName: turnName, order: turnOrder!, frame: CGRectMake(x, y, width, height))
                    view.addSubview(selectableTurn)
                    
                } else {
                    selectableTurn.frame = CGRectMake(x, y, width, height)
                    selectableTurn.selectOrderColor(turnOrder!)
                    selectableTurn.prepareTurnLabel(turnName)
                    selectableTurn.loadUI()
                }
                selectableTurn.alpha = 0.0
                selectableTurn.fadeIn()
                txtTurno.text = turnName
                senderParent?.selected = true
                btnDeleteTurn.fadeIn()
                btnDeleteTurn.enabled = true
            } else {
                
                txtTurno.text = ""
                senderParent?.selected = false
                selectableTurn.fadeOut()
                btnDeleteTurn.fadeOut()
                btnDeleteTurn.enabled = false
                selectedTurn = nil
                
            }
            
            
            
        }
    }
    
    func animateSelection() {
        
    }
    
    
    

    @IBAction func deleteTurn(sender: MenuButton) {
        //sharedHelper.dele
        if selectedTurn != nil {
            if let index = turns.indexOf({$0.turnLabel.text == selectedTurn?.idTurno! }) {
             rearrangeSubviewsAfterDeletingTurn(turns[index], atIndex: index)
            }
            sharedHelper.deleteEntity(selectedTurn)
            selectableTurn.fadeOut()
            btnDeleteTurn.fadeOut()
            selectedTurn = nil
            btnDeleteTurn.enabled = false
        }
    }
    
    
    func rearrangeSubviewsAfterDeletingTurn(selectedView : TurnView, atIndex vIndex: Int) {
        var deletedViewFrame = selectedView.frame
        
        if selectedView == turns.last {
            selectedView.removeFromSuperview()
            turns.removeAtIndex(vIndex)
            return
        }
        selectedView.removeFromSuperview()
        for (index, element) in turns.enumerate()  {
            if index == 0 {
                
            } else if index > vIndex {
                let oldFrame = element.frame
                
                element.changePosition(to: deletedViewFrame)
                deletedViewFrame = oldFrame
            }
        }
        turns.removeAtIndex(vIndex)
        
    }
    
    func validateAndAvance() {
        if turnObjects.count > 1 {
            performSegueWithIdentifier("firstStepSegue", sender: self)
            
            
            
        } else {
            let alert = UIAlertController(title: "Alerta", message: "Necesita haber más de una guardia para poder continuar.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "Ok", style: .Default, handler: { void in
                self.txtTurno.resignFirstResponder()
            })
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func placeExistingTurns() {
        for turno in turnObjects {
            let lastTurn = turns.last
            var yPosition =  btnAddTurn.frame.origin.y + btnAddTurn.frame.size.height + 25
            var xPosition = (lastTurn != nil) ? CGFloat(lastTurn!.frame.origin.x + lastTurn!.frame.size.width + 20) : CGFloat(20)
            
            if lastTurn != nil && lastTurn!.frame.origin.y >  btnAddTurn.frame.origin.y + btnAddTurn.frame.size.height + 15 {
                yPosition = lastTurn!.frame.origin.y
            }
            
            if (lastTurn != nil && xPosition + lastTurn!.frame.size.width > self.view.frame.size.width) {
                yPosition = CGFloat(lastTurn!.frame.origin.y + lastTurn!.frame.size.height + 20)
                xPosition = CGFloat(20)
            }
            let newTurnView = TurnView(turnName: turno.idTurno! , order: Int(turno.ordenTurno!)!, frame: CGRectMake(xPosition, yPosition, 40, 40))
            self.view.addSubview(newTurnView)
            let tap = UITapGestureRecognizer(target: self, action: #selector(GMCreacionTurnosViewController.handleTap(_:)))
            newTurnView.addGestureRecognizer(tap)
            turns.append(newTurnView)
        }
    }
    
    
    //MARK: - Validations
    
    func validTextfieldInput() -> Bool {
        if turns.count > 40 {
            let alert = UIAlertController(title: "Alerta", message: "Por el momento solo se permite un máximo de 7 turnos.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "Ok", style: .Default, handler: { void in
                self.txtTurno.resignFirstResponder()
            })
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
            return false
        }
        
        if txtTurno.text?.characters.count > 1 {
            let alert = UIAlertController(title: "Alerta", message: "Por el momento solo se permite el uso de una sola letra o número para asignar turnos.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "Ok", style: .Default, handler: { void in
                self.txtTurno.resignFirstResponder()
            })
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
            return false
        }
        let existingInstance = self.sharedHelper.singleInstanceOf("Turno", where: "idTurno", isEqualTo: txtTurno.text)
        if existingInstance != nil {
            let alert = UIAlertController(title: "Alerta", message: "Ya existe un turno con ese identificador, por favor elige otro.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "Ok", style: .Default, handler: { void in
                self.txtTurno.resignFirstResponder()
            })
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
            return false
        }
        
        
        return true
    }
    
    func checkForDuplicates() {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if hasLaunchedScreen == false {
            placeExistingTurns()
            hasLaunchedScreen = true
        }
    }
    
   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "firstStepSegue" {
            //let destination = segue.destinationViewController as! ViewController
            
        }
    }
    
    // MARK: Textdfield Delegate
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.becomeFirstResponder()
        let extraSpace = CGFloat(0)
        let textFieldFrame = textField.frame
        var currentFrame = self.view.frame
        
        if ((textFieldFrame.origin.y + textFieldFrame.size.height) > (self.view.frame.height / 2)) {
            currentFrame.origin.y = ((self.view.frame.size.height / 2) - (textFieldFrame.origin.y + textFieldFrame.size.height)) - 40 - extraSpace
        }
        UIView.animateWithDuration(0.9, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { 
            if self.view.frame.size.height > 500 && self.view.frame.size.height < 1000 {
                self.view.frame = currentFrame
            } else if self.view.frame.size.height > 1000 {
                
            } else {
                self.view.frame = currentFrame
            }
            
            }) { (completed) in
                
        }
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
        UIView.animateWithDuration(0.9, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
             self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        }) { (completed) in
            
        }

       
    }
    


//    -(void)textFieldDidEndEditing:(UITextField *)textField
//    {
//    [textField resignFirstResponder];
//    BOOL hasNextTxt = NO;
//    
//    UITextField *view =(UITextField *)[self.view viewWithTag:textField.tag + 1];
//    if (!view){
//    [textField resignFirstResponder];
//    }else{
//    hasNextTxt = YES;
//    [view becomeFirstResponder];
//    }
//    UIScrollView *scrollView;
//    if ([textField.superview isKindOfClass:[UIScrollView class]]) {
//    scrollView = (UIScrollView *)textField.superview;
//    self.hasScrollView = YES;
//    scrollView.scrollEnabled = YES;
//    }
//    //[textField resignFirstResponder];
//    [UIView animateWithDuration:0.6
//    delay:0.0
//    options:UIViewAnimationOptionCurveEaseOut
//    animations:^{
//    if (!hasNextTxt) {
//    if (self.hasScrollView) {
//    [scrollView setContentOffset:CGPointMake(0, 50)];
//    }else{
//    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    }
//    }
//    }
//    completion:^(BOOL finished) {
//    }
//    
//    ];
//    //return YES;
//    }

    

}
