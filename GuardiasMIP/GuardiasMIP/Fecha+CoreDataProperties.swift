//
//  Fecha+CoreDataProperties.swift
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

extension Fecha {

    @NSManaged var idFecha: String?
    @NSManaged var idTurno: String?
    @NSManaged var fechaTurno: String?
    @NSManaged var turnoFecha: Turno?

}
