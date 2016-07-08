//
//  ViewController.swift
//  GuardiasMIP
//
//  Created by Ernesto Sánchez Kuri on 26/06/16.
//  Copyright © 2016 Sankurlabs. All rights reserved.
//

import UIKit
import EasyPickerKit.CustomPickerViewController
import EasyPickerKit.CustomDatePickerViewController

class ViewController: UIViewController, CustomDatePickerDelegate, EPCalendarPickerDelegate {
    @IBOutlet weak var btnStartingDate: UIButton!
    @IBOutlet weak var btnEndingDate: UIButton!
    var datePicker = CustomDatePickerViewController()
    var sharedHelper =  (UIApplication.sharedApplication().delegate as! AppDelegate)._coreDataHelper
    var selectedStartingDate : NSDate?
    var selectedEndingDate :NSDate?
    var selectedDates = ["inicioTurno" : "", "finTurno" : ""]
    var turnObjects = [Turno!]()
    
    @IBOutlet weak var btnNext: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()
        retrieveExistingTurns()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    lazy var activityIndicator : ActivityIndicator = {
        let indicator =  self.storyboard?.instantiateViewControllerWithIdentifier("activityIndicator") as? ActivityIndicator
        indicator?.providesPresentationContextTransitionStyle = true
        indicator?.modalPresentationStyle = .OverCurrentContext
        
        return indicator!
    }()
    
    func loadUI() {
        //_ = activityIndicator()
        btnStartingDate.addTarget(self, action: #selector(ViewController.showDatePicker(_:)), forControlEvents: .TouchUpInside)
        btnEndingDate.addTarget(self, action: #selector(ViewController.showDatePicker(_:)), forControlEvents: .TouchUpInside)
        datePicker = CustomDatePickerViewController.init(delegate: self)
        
        datePicker.pickerHeight = self.view.frame.size.height
        btnNext.action = #selector(ViewController.validateToAdvance)
        btnNext.target = self
        
        btnStartingDate.titleLabel?.textAlignment = .Center
        btnEndingDate.titleLabel?.textAlignment = .Center
        
    }
    
    func retrieveExistingTurns() {
        turnObjects = self.sharedHelper.savedObjectInstanceFromObjectWithName("Turno", onDatabaseWithConditions: nil) as! [Turno!]
        
    }
    
    func showDatePicker(btn : UIButton) {
        var parent = self.parentViewController?.parentViewController
        if parent == nil {
            parent = self.parentViewController
        }
        if parent == nil {
            parent = self
        }
        if btn.tag == 1001 {
            datePicker.pickerTag = 1001
        } else {
            datePicker.pickerTag = 1002
        }
        
        datePicker.showDatePickerInViewController(self)
        
    }
    
    func picker(picker: CustomDatePickerViewController!, pickedDate date: NSDate!) {
        let dateFormatted = date.toString(format: DateFormat.ISO8601(.Date))
        switch picker.pickerTag as! Int {
        case 1001:
            btnStartingDate.titleLabel?.text = "\(dateFormatted)"
            selectedDates["inicioTurno"] = dateFormatted
            selectedStartingDate = date
            break
        case 1002:
            btnEndingDate.titleLabel?.text = "\(dateFormatted)"
            selectedDates["finTurno"] = dateFormatted
            selectedEndingDate = date
            break
        default:
            break
        }
    }
    
    func validateToAdvance() {
        if selectedStartingDate == nil || selectedEndingDate == nil {
            let alert = UIAlertController(title: "Alerta", message: "Tienes que seleccionar una fecha de inicio y una de fin para generar el calendario correspondiente", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "Ok", style: .Default, handler: { void in
            })
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
            return;
        }
        
        
        if selectedEndingDate!.isEarlierThanDate(selectedStartingDate!) {
            let alert = UIAlertController(title: "Alerta", message: "La fecha de fin debe de ser mayor a la fecha de inicio.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "Ok", style: .Default, handler: { void in
            })
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
            return;
        }
        
        var turnCount = 0
        let last = turnObjects.count
        presentViewController(activityIndicator, animated: true) {
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                // do some task
                for currentTurn in self.turnObjects {
                    let turn = self.newTurn(currentTurn)
                    
                    
                    self.sharedHelper.updateExistingInstanceFromObjectWithName("Turno", usingParams: turn, withMainIdentifier: "idTurno", withSuccess: { (success) in
                        
                    }) { (errorString, errorDict) in
                        
                    }
                }
                dispatch_async(dispatch_get_main_queue()) {
                    // update some UI
                    self.hacerCalculos()
                }
            }
            
            
        }
        
    }
    
    
    func newTurn(_turn : Turno) -> [String : String]? {
        let turn = [    "idTurno": _turn.idTurno!,
                        "nombreTurno" : _turn.nombreTurno!,
                        "inicioTurno" : selectedDates["inicioTurno"]!,
                        "finTurno"    : selectedDates["finTurno"]!,
                        "colorTurno"  : _turn.colorTurno!,
                        "ordenTurno"  : _turn.ordenTurno!
        ]
        return turn
        
    }
    
    
    func hacerCalculos() {
        
        let startingDate = NSDate(fromString: turnObjects[0].inicioTurno!, format: DateFormat.ISO8601(.Date))
        CalendarBrain.getStartingYear(startingDate)
        CalendarBrain.getStartingMonth(startingDate)
        
        CalendarBrain.getTurnDates(turnObjects) { (result) in
            print("Finished")
            self.activityIndicator.stopAnimationWithSuccess({ (stoped) in
                let endingDate = NSDate(fromString: self.turnObjects[0].finTurno!, format: DateFormat.ISO8601(.Date))
                CalendarBrain.getEndingYear(endingDate)
                CalendarBrain.getEndingMonth(endingDate)
                let calendarPicker = EPCalendarPicker(startYear: CalendarBrain.getStartingYear(startingDate), startingMonth: CalendarBrain.getStartingMonth(startingDate), endYear: CalendarBrain.getEndingYear(endingDate), endMonth: CalendarBrain.getEndingMonth(endingDate), multiSelection: true, selectedDates: nil)
                calendarPicker.calendarDelegate = self
                calendarPicker.lastView = self
                let navigationController = UINavigationController(rootViewController: calendarPicker)
                self.presentViewController(navigationController, animated: true, completion: nil)
            })
            
        }
        
    }
    
    func datePickerWasCancelled(picker: CustomDatePickerViewController!) {
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "secondStepSegue" {
            //let destination = segue.destinationViewController as! ViewController
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

