//
//  Vaccination+CoreDataProperties.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 30.05.22.
//
//

import Foundation
import CoreData


extension Vaccination {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Vaccination> {
        return NSFetchRequest<Vaccination>(entityName: "Vaccination")
    }

    @NSManaged public var certificates: Data?
    @NSManaged public var timestamp: Date?
    @NSManaged public var passName: String?
    @NSManaged public var valid: Bool
    @NSManaged public var pass: VaccinationPass?
    @NSManaged public var target: DiseaseTarget?
    @NSManaged public var vaccine: Vaccine?

}

extension Vaccination : Identifiable {

}
