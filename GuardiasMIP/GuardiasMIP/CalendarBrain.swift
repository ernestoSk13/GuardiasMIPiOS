//
//  CalendarBrain.swift
//  GuardiasMIP
//
//  Created by Ernesto Sánchez Kuri on 05/07/16.
//  Copyright © 2016 Sankurlabs. All rights reserved.
//

import UIKit
import UserNotifications
//import SuperCoreData.CoreDataHelper

class CalendarBrain: NSObject {
   
    
    
    
    
    class func getStartingYear(date: NSDate) -> Int {
        let year = date.toString(format: .Custom("YYYY"))
        return Int(year)!
    }
    
    class func getEndingYear(date: NSDate) -> Int {
         let year = date.toString(format: .Custom("YYYY"))
        return Int(year)!
    }
    
    class func getStartingMonth(date: NSDate) -> Int {
        let month = date.toString(format: .Custom("MM"))
        return Int(month)!
    }
    
    class func getEndingMonth(date: NSDate) -> Int {
        let month = date.toString(format: .Custom("MM"))
        return Int(month)!
    }
    
    class func getTurnDates(turnArray: [Turno!], completion: (result: String) -> Void) {
        var startingDate = NSDate(fromString: turnArray.last!.inicioTurno!, format: DateFormat.ISO8601(.Date))
        let endingDate = NSDate(fromString: turnArray.last!.finTurno!, format: DateFormat.ISO8601(.Date))
    
        var arrayIndex = 0
        let sharedHelper =  (UIApplication.sharedApplication().delegate as! AppDelegate)._coreDataHelper
        
        while !startingDate.isEqualToDate(endingDate) {
            
            let currentTurn = turnArray[arrayIndex]
            let dateString = startingDate.toString(format: DateFormat.ISO8601(.Date))
            let fechas = sharedHelper.savedObjectInstanceFromObjectWithName("Fecha", onDatabaseWithConditions: nil)
            let newDate = ["idTurno" : currentTurn.idTurno!, "fechaTurno": dateString, "idFecha" : "\(fechas.count + 1)"]
            
            sharedHelper.setNewInstanceFromObjectWithName("Fecha", usingParams: newDate, withMainIdentifier: "idFecha", withSuccess: { (success) in
                
                }, orError: { (errorStr, errorDict) in
                    
            })
            
            
            
            let fecha = sharedHelper.singleInstanceOf("Fecha", where: "idFecha", isEqualTo: newDate["idFecha"])  as! Fecha
            fecha.turnoFecha = currentTurn
            //currentTurn.addDateToTurn(fecha)
            do {
            try sharedHelper.managedObjectContext.save()
            } catch {
                print("Error")
            }
            
            startingDate = startingDate.dateByAddingDays(1)
            arrayIndex += 1
            if arrayIndex > turnArray.count - 1 {
                arrayIndex = 0
            }
            
        }
        
        completion(result: "Finished")
        
    }
    
    class func scheduleNotificationsForTurn(turno: Turno) {
//        if #available(iOS 10.0, *) {
//            let content = UNMutableNotificationContent()
//            content.title = "Hoy toca guardia al grupo: \(turno.idTurno!)"
//            content.body = "Para ver el calendario accede a la aplicación dando tap a esta notificación."
//            
//            
//            for fecha  in turno.fechaTurno! {
//                if let _fecha = fecha as? Fecha {
//                    print("Fecha -----> \(_fecha.fechaTurno!)")
//                    let fechaFormateada = NSDate(fromString: _fecha.fechaTurno!,  format: DateFormat.ISO8601(.Date))
//                    
//                    if fechaFormateada.isToday() {
//                        let dateComponents = NSDateComponents()
//                        dateComponents.day = fechaFormateada.day()
//                        dateComponents.year = fechaFormateada.year()
//                        dateComponents.month = fechaFormateada.month()
//                        dateComponents.hour = 1
//                        dateComponents.minute = 7
//                        
//                        let trigger = UNCalendarNotificationTrigger(dateMatchingComponents: dateComponents, repeats: false)
//                        let request = UNNotificationRequest.init(identifier: "notificacionMIP", content: content, trigger: trigger)
//                        
//                        // Schedule the notification.
//                        let center = UNUserNotificationCenter.currentNotificationCenter()
//                        center.addNotificationRequest(request, withCompletionHandler: { (error) in
//                            
//                            print("Error \(error)")
//                            
//                        })
//                        
//                    }
//                    
//                   
//                }
//                
//                
//                
//            }
//            
//            
//
//        } else {
//            // Fallback on earlier versions
//        }
    }
  
    
    
}
