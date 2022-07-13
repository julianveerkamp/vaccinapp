//
//  dto.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 22.04.22.
//

import Foundation

enum Gender: String {
    case none = "none"
    case male = "male"
    case female = "female"
}

enum PassType: String, Equatable, CaseIterable  {
    case human = "human"
    case cat = "cat"
    case dog = "dog"
    
    var emoji: String {
        switch self {
        case .human:
            return "👤"
        case .cat:
            return "🐱"
        case .dog:
            return "🐶"
        }
    }
}

enum Country: String, Equatable, CaseIterable {
    case all = "all"
    case germany = "germany"
    case greece = "greece"
    case thailand = "thailand"
    
    var emoji: String {
        switch self {
        case .all:
            return ["🌎", "🌍", "🌏"].shuffled().first!
        case .germany:
            return "🇩🇪"
        case .greece:
            return "🇬🇷"
        case .thailand:
            return "🇹🇭"
        }
    }
}

struct AddVaccinationDTO {
    var timestamp: Date
    var diseaseSelection: DiseaseTarget
    var vaccineSelection: Vaccine
    var valid: Bool
    var certificates: [ExtendedCBORWebToken]
}
