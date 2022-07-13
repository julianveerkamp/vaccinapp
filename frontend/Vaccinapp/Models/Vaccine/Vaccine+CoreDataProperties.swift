//
//  Vaccine+CoreDataProperties.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 05.06.22.
//
//

import Foundation
import CoreData


extension Vaccine {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Vaccine> {
        return NSFetchRequest<Vaccine>(entityName: "Vaccine")
    }
    
    @NSManaged public var name: String
    @NSManaged public var manufacturer: String
    @NSManaged public var id: String
    @NSManaged public var target: DiseaseTarget?
    
}

extension Vaccine : Identifiable {
    
}
