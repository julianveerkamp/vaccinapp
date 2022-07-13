//
//  RecommendationsResponse.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 27.05.22.
//

import Foundation
import Combine

struct RecommendationsResponse: Codable {
    var recommendations: [DiseaseTargetDTO]
}

struct DiseaseTargetDTO: Codable {
    var targetID: String
    var type: String
    var vaccines: [VaccineDTO]
    var age: String?
    var gender: String?
    var name: String
    var countries: [String]?
}

struct VaccineDTO: Codable {
    var id: String
    var name: String
    var manufacturer: String
}
