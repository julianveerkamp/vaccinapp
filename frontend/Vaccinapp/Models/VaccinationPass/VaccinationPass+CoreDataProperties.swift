//
//  VaccinePass+CoreDataProperties.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 10.05.22.
//
//

import Foundation
import CoreData


extension VaccinationPass {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VaccinationPass> {
        return NSFetchRequest<VaccinationPass>(entityName: "VaccinationPass")
    }

    @NSManaged public var dob: Date
    @NSManaged public var name: String
    @NSManaged public var gender: String
    @NSManaged public var type: String
    @NSManaged public var vaccines: NSSet?
    @NSManaged public var selected: DefaultPass?

}

// MARK: Generated accessors for vaccines
extension VaccinationPass {

    @objc(addVaccinesObject:)
    @NSManaged public func addToVaccines(_ value: Vaccination)

    @objc(removeVaccinesObject:)
    @NSManaged public func removeFromVaccines(_ value: Vaccination)

    @objc(addVaccines:)
    @NSManaged public func addToVaccines(_ values: NSSet)

    @objc(removeVaccines:)
    @NSManaged public func removeFromVaccines(_ values: NSSet)
    
}

extension VaccinationPass : Identifiable {

}
