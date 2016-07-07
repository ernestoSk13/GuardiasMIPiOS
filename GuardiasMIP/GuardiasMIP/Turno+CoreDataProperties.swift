//
//  Turno+CoreDataProperties.swift
//  GuardiasMIP
//
//  Created by Ernesto Sánchez Kuri on 06/07/16.
//  Copyright © 2016 Sankurlabs. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Turno {

    @NSManaged var colorTurno: String?
    @NSManaged var finTurno: String?
    @NSManaged var idTurno: String?
    @NSManaged var inicioTurno: String?
    @NSManaged var nombreTurno: String?
    @NSManaged var ordenTurno: String?
    @NSManaged var fechaTurno: NSSet?
    
    func addDateToTurn(date:Fecha) {
        let fechas = self.mutableSetValueForKey("fechaTurno")
        fechas.addObject(date)
    }
    
    func getNumberOfDates() -> Int {
        return self.fechaTurno!.count;
    }
    
    func getTeams() -> [Fecha] {
        var tmpsak: [Fecha]
        tmpsak = self.fechaTurno!.allObjects as! [Fecha]
        tmpsak = self.fechaTurno!.allObjects as! [Fecha]
        
        return tmpsak
    }
    

}
