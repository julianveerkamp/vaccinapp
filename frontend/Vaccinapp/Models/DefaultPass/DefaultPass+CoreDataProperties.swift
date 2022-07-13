//
//  DefaultPass+CoreDataProperties.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 10.05.22.
//
//

import Foundation
import CoreData


extension DefaultPass {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DefaultPass> {
        return NSFetchRequest<DefaultPass>(entityName: "DefaultPass")
    }
    
    @NSManaged public var pass: VaccinationPass?
    
}

extension DefaultPass : Identifiable {
    
}
