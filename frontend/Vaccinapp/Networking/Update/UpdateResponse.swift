//
//  UpdateResponse.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 03.06.22.
//

import Foundation

struct UpdateResponse: Codable {
    var items: [DiseaseTargetDTO]
}
