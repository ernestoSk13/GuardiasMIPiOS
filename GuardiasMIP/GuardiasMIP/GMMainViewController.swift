//
//  GMMainViewController.swift
//  GuardiasMIP
//
//  Created by Ernesto Sánchez Kuri on 06/07/16.
//  Copyright © 2016 Sankurlabs. All rights reserved.
//

import UIKit
import UserNotifications
//import SuperCoreData.CoreDataHelper

class GMMainViewController: UIViewController, EPCalendarPickerDelegate {
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var btnNuevoRol: MenuButton!
    @IBOutlet weak var btnRolActual: MenuButton!
    var sharedHelper =  (UIApplication.sharedApplication().delegate as! AppDelegate)._coreDataHelper
    var turnos = [Turno!]()
    var fechas = [Fecha!]()
    
    @IBOutlet weak var lblTurnoActual: UILabel!
    
    lazy var activityIndicator : ActivityIndicator = {
        let indicator =  self.storyboard?.instantiateViewControllerWithIdentifier("activityIndicator") as? ActivityIndicator
        indicator?.providesPresentationContextTransitionStyle = true
        indicator?.modalPresentationStyle = .OverCurrentContext
        
        return indicator!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageDancing))
        imgLogo.userInteractionEnabled = true
        imgLogo.addGestureRecognizer(tap)
        rateMe()
    }
    
    
    func imageDancing() {
        let dancingAnimation = CABasicAnimation(keyPath: "transform.rotation")
        dancingAnimation.duration = 0.5
        dancingAnimation.additive = true
        dancingAnimation.removedOnCompletion = true
        dancingAnimation.repeatCount = 3.0
        dancingAnimation.autoreverses = true
        dancingAnimation.fillMode = kCAFillModeForwards
        dancingAnimation.fromValue = NSNumber.init(float: 0)
        dancingAnimation.toValue = NSNumber.init(float: (360 * 3.141516) * 0.066/180)
        
        self.imgLogo.layer.addAnimation(dancingAnimation, forKey: "transform.rotation")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        retrieveInfo()
        loadUI()
    }
    
    func loadUI() {
        btnNuevoRol.addTarget(self, action: #selector(GMMainViewController.nuevoRol), forControlEvents: UIControlEvents.TouchUpInside)
        if turnos.count > 0 {
            guard turnos[0].inicioTurno != nil else {
                for turno in self.turnos {
                    self.sharedHelper.deleteEntity(turno!)
                }
                btnRolActual.hidden = true
                lblTurnoActual.hidden = true
                return
            }
            
            turnoActual()
            btnRolActual.hidden = false
            btnRolActual.addTarget(self, action: #selector(GMMainViewController.mostrarRolActual), forControlEvents: UIControlEvents.TouchUpInside)
        } else {
            btnRolActual.hidden = true
            lblTurnoActual.hidden = true
        }
        if self.view.frame.size.height < 500 {
            print("iphone 4")
            var imgFrame = imgLogo.frame
            imgFrame.origin.y += 160
            imgLogo.frame = imgFrame
            
            var btnOneFrame = btnNuevoRol.frame
            btnOneFrame.origin.y += 160
            btnNuevoRol.frame = btnOneFrame
            
            var btnTwoFrame = btnRolActual.frame
            btnTwoFrame.origin.y += 160
            btnRolActual.frame = btnTwoFrame
        }
    }
    
   
    
    
    
    func turnoActual() {
        let currentDate = NSDate()
        let fecha = currentDate.toString(format: DateFormat.ISO8601(.Date))
        let correspodingDate = sharedHelper.singleInstanceOf("Fecha", where: "fechaTurno", isEqualTo: fecha) as? Fecha
        if correspodingDate != nil {
            lblTurnoActual.hidden = false
            lblTurnoActual.text = "Hoy toca guardia al grupo: \(correspodingDate!.idTurno!)"
            CalendarBrain.scheduleNotificationsForTurn((correspodingDate?.turnoFecha!)!)
            
        }
    }
    
    
    func nuevoRol() {
        let segue = "newRoleSegue"
        
        presentViewController(activityIndicator, animated: true) {
            for turno in self.turnos {
                self.sharedHelper.deleteEntity(turno!)
            }
            
            for fecha in self.fechas {
                self.sharedHelper.deleteEntity(fecha)
            }
        }
        activityIndicator.stopAnimationWithSuccess({ (success) in
            self.performSegueWithIdentifier(segue, sender: self)
        })
        
        
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
    
    //MARK: Rate me
    
    var iMinSessions = 3
    var iTryAgainSessions = 6
    var facebookSessions = 9
    
    func rateMe() {
        let neverRate = NSUserDefaults.standardUserDefaults().boolForKey("neverRate")
        let neverRateFacebook = NSUserDefaults.standardUserDefaults().boolForKey("neverRateFacebook")
        var numLaunches = NSUserDefaults.standardUserDefaults().integerForKey("numLaunches") + 1
        
        if (!neverRate && (numLaunches == iMinSessions || numLaunches >= (iMinSessions + iTryAgainSessions + 1)))
        {
            showRateMe()
            numLaunches = iMinSessions + 1
        }
        
        if (!neverRateFacebook && numLaunches == facebookSessions || numLaunches == facebookSessions * 2) {
            showFacebookPrompt()
        }
        
        
        NSUserDefaults.standardUserDefaults().setInteger(numLaunches, forKey: "numLaunches")
    }
    
    
    func showFacebookPrompt() {
        let alert = UIAlertController(title: "Ya tenemos página en Facebook", message: "Nos gustaría saber tú opinión y sugerencias en nuestra página de Facebook", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ir a página de Facebook", style: UIAlertActionStyle.Default, handler: { alertAction in
            if (UIApplication.sharedApplication().canOpenURL(NSURL(string :"fb://profile/1824677437770240")!)) {
                UIApplication.sharedApplication().openURL(NSURL(string: "fb://profile/1824677437770240")!)
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "neverRateFacebook")
            } else {
                UIApplication.sharedApplication().openURL(NSURL(string: "https://www.facebook.com/mipcalendario/?ref=aymt_homepage_panel")!)
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "neverRateFacebook")
            }
            
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No gracias", style: UIAlertActionStyle.Default, handler: { alertAction in
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "neverRateFacebook")
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Tal vez después", style: UIAlertActionStyle.Default, handler: { alertAction in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showRateMe() {
        let alert = UIAlertController(title: "Ayúdanos a mejorar", message: "Gracias por utilizar MIP Calendario. Nos gustaría saber tú opinión y sugerencias calificándonos en el App Store", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Calificar MIP Calendario", style: UIAlertActionStyle.Default, handler: { alertAction in
            UIApplication.sharedApplication().openURL(NSURL(string : "https://itunes.apple.com/es/app/mip-calendario/id1132442892")!)
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No gracias", style: UIAlertActionStyle.Default, handler: { alertAction in
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "neverRate")
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Tal vez después", style: UIAlertActionStyle.Default, handler: { alertAction in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
