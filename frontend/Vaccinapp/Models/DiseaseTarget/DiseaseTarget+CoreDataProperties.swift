//
//  DiseaseTarget+CoreDataProperties.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 05.06.22.
//
//

import Foundation
import CoreData


extension DiseaseTarget {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiseaseTarget> {
        return NSFetchRequest<DiseaseTarget>(entityName: "DiseaseTarget")
    }
    
    @NSManaged public var id: String?
    @NSManaged public var name: String
    @NSManaged public var type: String
    @NSManaged public var recommendation: Recommendation?
    @NSManaged public var vaccinations: NSSet?
    @NSManaged public var vaccines: NSSet?
    
}

// MARK: Generated accessors for vaccination
extension DiseaseTarget {
    
    @objc(addVaccinationsObject:)
    @NSManaged public func addToVaccinations(_ value: Vaccination)
    
    @objc(removeVaccinationsObject:)
    @NSManaged public func removeFromVaccinations(_ value: Vaccination)
    
    @objc(addVaccinations:)
    @NSManaged public func addToVaccinations(_ values: NSSet)
    
    @objc(removeVaccinations:)
    @NSManaged public func removeFromVaccinations(_ values: NSSet)
    
}

// MARK: Generated accessors for vaccination
extension DiseaseTarget {
    
    @objc(addVaccinesObject:)
    @NSManaged public func addToVaccines(_ value: Vaccine)
    
    @objc(removeVaccinesObject:)
    @NSManaged public func removeFromVaccines(_ value: Vaccine)
    
    @objc(addVaccines:)
    @NSManaged public func addToVaccines(_ values: NSSet)
    
    @objc(removeVaccines:)
    @NSManaged public func removeFromVaccines(_ values: NSSet)
    
}

extension DiseaseTarget : Identifiable {
    
}
