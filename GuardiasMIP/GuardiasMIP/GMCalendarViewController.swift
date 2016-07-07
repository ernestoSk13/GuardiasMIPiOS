//
//  GMCalendarViewController.swift
//  GuardiasMIP
//
//  Created by Ernesto Sánchez Kuri on 05/07/16.
//  Copyright © 2016 Sankurlabs. All rights reserved.
//

import UIKit

class GMCalendarViewController: UIViewController, EPCalendarPickerDelegate {
    
    @IBOutlet weak var calendarContainer: UIView!
    var sharedHelper =  (UIApplication.sharedApplication().delegate as! AppDelegate)._coreDataHelper
    var turnos = [Turno!]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveInfo()
        loadUI()
        
        
    }
    
    
    func loadUI() {
        
        
        hacerCalculos()
        
        let calendarPicker = EPCalendarPicker(startYear: 2015, startingMonth: 3, endYear: 2017, endMonth: 12, multiSelection: true, selectedDates: nil)
        calendarPicker.calendarDelegate = self
        self.addChildViewController(calendarPicker)
        self.addSubview(calendarPicker.view, toView: calendarContainer)
    }
    
    func addSubview(subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
    }
    
    
    func hacerCalculos() {
        let startingDate = NSDate(fromString: turnos[0].inicioTurno!, format: DateFormat.ISO8601(.Date))
        CalendarBrain.getStartingYear(startingDate)
        
        let endingDate = NSDate(fromString: turnos[0].finTurno!, format: DateFormat.ISO8601(.Date))
        CalendarBrain.getEndingYear(endingDate)
    }
    
    func retrieveInfo() {
        turnos = self.sharedHelper.savedObjectInstanceFromObjectWithName("Turno", onDatabaseWithConditions: nil) as! [Turno!]
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
       
    }

}
