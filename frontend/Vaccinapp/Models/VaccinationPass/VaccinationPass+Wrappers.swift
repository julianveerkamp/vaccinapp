//
//  VaccinePass+Wrappers.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 10.05.22.
//

import Foundation
import CoreData

extension VaccinationPass {
    public var wrappedVaccines: [Vaccination] {
        let set = vaccines as? Set<Vaccination> ?? []
        return set.sorted()
    }
    
    var wrappedGender: Gender {
        get {
            return Gender(rawValue: gender) ?? Gender.none
        }
        set {
            gender = newValue.rawValue
        }
    }
    
    var wrappedType: PassType {
        get {
            return PassType(rawValue: type) ?? PassType.human
        }
        set {
            type = newValue.rawValue
        }
    }
    
    var age: Int16 {
        Int16(Calendar.current.dateComponents([.year], from: dob , to: Date()).year!) 
    }
}

extension VaccinationPass: Encodable {
    enum CodingKeys: CodingKey {
        case name, vaccinations, gender, type, dob
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(gender, forKey: .gender)
        try container.encode(type, forKey: .type)
        try container.encode(dob, forKey: .dob)
        try container.encode(wrappedVaccines, forKey: .vaccinations)
    }
}

extension VaccinationPass {
    static func getByName(_ name: String) -> NSFetchRequest<VaccinationPass> {
        let request = VaccinationPass.fetchRequest()
        
        let predicate = NSPredicate(format: "name == %@", name)
        
        request.predicate = predicate
        
        return request
    }
}
