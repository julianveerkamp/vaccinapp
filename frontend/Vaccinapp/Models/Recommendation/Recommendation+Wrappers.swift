//
//  Recommendation+Wrappers.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 30.05.22.
//

import Foundation
import CoreData


extension Recommendation {
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
    
    var wrappedCountries: [Country] {
        var result = [Country]()
        for c in countries ?? [] {
            if let country = Country(rawValue: c) {
                result.append(country)
            } else {
                print("Error Handling")
            }
        }
        return result
    }
    
    var text: String {
        var text = "The vaccination against \(target?.name ?? "MISSING") is recommended for all "
        switch wrappedGender {
        case .none:
            break
        case .male:
            text.append("male ")
        case .female:
            text.append("female ")
        }
        text.append("patients")
        
        if self.age > 0 {
            text.append(" aged \(age) or above")
        }
        text.append(".")
        
        return text
    }
}

