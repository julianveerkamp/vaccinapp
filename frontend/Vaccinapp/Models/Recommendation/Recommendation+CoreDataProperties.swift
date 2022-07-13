//
//  Recommendation+CoreDataProperties.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 06.05.22.
//
//

import Foundation
import CoreData


extension Recommendation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recommendation> {
        return NSFetchRequest<Recommendation>(entityName: "Recommendation")
    }

    @NSManaged public var age: Int16
    @NSManaged public var countries: Array<String>?
    @NSManaged public var type: String
    @NSManaged public var gender: String
    @NSManaged public var target: DiseaseTarget?

}

extension Recommendation : Identifiable {

}
