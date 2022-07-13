//
//  DiseaseTarget+Wrappers.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 13.05.22.
//

import Foundation
import CoreData

extension DiseaseTarget: Encodable {
    enum CodingKeys: CodingKey {
        case name, id, type
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
    }
    
}

extension DiseaseTarget {
    var wrappedType: PassType {
        get {
            return PassType(rawValue: type) ?? PassType.human
        }
        set {
            type = newValue.rawValue
        }
    }
    
    public var wrappedVaccinations: [Vaccination] {
        let set = vaccinations as? Set<Vaccination> ?? []
        return set.sorted()
    }
    
    public var wrappedVaccines: [Vaccine] {
        let set = vaccines as? Set<Vaccine> ?? []
        return set.sorted()
    }
}

extension DiseaseTarget {
    static func allRecommendedTargets(for pass: VaccinationPass) -> NSFetchRequest<DiseaseTarget> {
        let gender = pass.wrappedGender
        let type = pass.wrappedType
        let age = pass.age
        
        let request = DiseaseTarget.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \DiseaseTarget.name, ascending: true)]
        
        
        let typePredicate = NSPredicate(format: "type == %@", type.rawValue)
        let recommended = NSPredicate(format: "%K != FALSE", #keyPath(DiseaseTarget.recommendation))
        let correctAge = NSPredicate(format: "%K <= %i", #keyPath(DiseaseTarget.recommendation.age), age)
        let correctGender = NSPredicate(format: "%K == 'none' OR %K == %@", #keyPath(DiseaseTarget.recommendation.gender), #keyPath(DiseaseTarget.recommendation.gender), gender.rawValue)
        
        var predicates: [NSPredicate] = [
            typePredicate,
            recommended,
            correctAge
        ]
        
        if gender != .none {
            predicates.append(correctGender)
        }
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.predicate = predicate
        
        return request
    }
    
    static func get(for idString: String) -> NSFetchRequest<DiseaseTarget> {
        let request = DiseaseTarget.fetchRequest()
        
        let predicate = NSPredicate(format: "id == %@", idString)
        
        request.predicate = predicate
        
        return request
    }
}
