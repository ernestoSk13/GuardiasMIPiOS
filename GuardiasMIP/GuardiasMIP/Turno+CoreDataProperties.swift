//
//  Turno+CoreDataProperties.swift
//  GuardiasMIP
//
//  Created by Ernesto Sánchez Kuri on 28/06/16.
//  Copyright © 2016 Sankurlabs. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Turno {

    @NSManaged var idTurno: String?
    @NSManaged var nombreTurno: String?
    @NSManaged var inicioTurno: String?
    @NSManaged var finTurno: String?
    @NSManaged var colorTurno: String?
    @NSManaged var ordenTurno: String?

}
