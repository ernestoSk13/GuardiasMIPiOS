//
//  GMMainViewController.swift
//  GuardiasMIP
//
//  Created by Ernesto Sánchez Kuri on 06/07/16.
//  Copyright © 2016 Sankurlabs. All rights reserved.
//

import UIKit
import SuperCoreData.CoreDataHelper

class GMMainViewController: UIViewController, EPCalendarPickerDelegate {

    @IBOutlet weak var btnNuevoRol: MenuButton!
    @IBOutlet weak var btnRolActual: MenuButton!
    var sharedHelper =  (UIApplication.sharedApplication().delegate as! AppDelegate)._coreDataHelper
    var turnos = [Turno!]()
    var fechas = [Fecha!]()
    
    @IBOutlet weak var lblTurnoActual: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        retrieveInfo()
        loadUI()
    }
    
    func loadUI() {
        
        btnNuevoRol.addTarget(self, action: #selector(GMMainViewController.nuevoRol), forControlEvents: UIControlEvents.TouchUpInside)
        if turnos.count > 0 {
           
            turnoActual()
            btnRolActual.hidden = false
            btnRolActual.addTarget(self, action: #selector(GMMainViewController.mostrarRolActual), forControlEvents: UIControlEvents.TouchUpInside)
        } else {
            btnRolActual.hidden = true
            lblTurnoActual.hidden = true
        }
    }
    
    func turnoActual() {
        let currentDate = NSDate()
        let fecha = currentDate.toString(format: DateFormat.ISO8601(.Date))
        let correspodingDate = sharedHelper.singleInstanceOf("Fecha", where: "fechaTurno", isEqualTo: fecha) as? Fecha
        if correspodingDate != nil {
             lblTurnoActual.hidden = false
            lblTurnoActual.text = "Hoy toca guardia al grupo: \(correspodingDate!.idTurno!)"
        }
}
    
    
    func nuevoRol() {
        let segue = "newRoleSegue"
        for turno in turnos {
            sharedHelper.deleteEntity(turno!)
        }
        
        for fecha in fechas {
            sharedHelper.deleteEntity(fecha)
        }
        
        
        
        self.performSegueWithIdentifier(segue, sender: self)
        
    }
    
    func retrieveInfo() {
        turnos = self.sharedHelper.savedObjectInstanceFromObjectWithName("Turno", onDatabaseWithConditions: nil) as! [Turno!]
        fechas = self.sharedHelper.savedObjectInstanceFromObjectWithName("Fecha", onDatabaseWithConditions: nil) as! [Fecha!]
    }
    
    func mostrarRolActual () {
        hacerCalculos()
    }
    
    func hacerCalculos() {
        let startingDate = NSDate(fromString: turnos[0].inicioTurno!, format: DateFormat.ISO8601(.Date))
        CalendarBrain.getStartingYear(startingDate)
        CalendarBrain.getStartingMonth(startingDate)
        
        
        let endingDate = NSDate(fromString: turnos[0].finTurno!, format: DateFormat.ISO8601(.Date))
        CalendarBrain.getEndingYear(endingDate)
        CalendarBrain.getEndingMonth(endingDate)
        let calendarPicker = EPCalendarPicker(startYear: CalendarBrain.getStartingYear(startingDate), startingMonth: CalendarBrain.getStartingMonth(startingDate), endYear: CalendarBrain.getEndingYear(endingDate), endMonth: CalendarBrain.getEndingMonth(endingDate), multiSelection: true, selectedDates: nil)
        calendarPicker.calendarDelegate = self
        let navigationController = UINavigationController(rootViewController: calendarPicker)
        self.presentViewController(navigationController, animated: true, completion: nil)
        
    }
}
