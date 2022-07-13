//
//  RecommendationsService.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 27.05.22.
//

import Foundation
import Combine

protocol RecommendationsService {
    var session: APIService {get}
    
    func get(_ country: Country) -> AnyPublisher<RecommendationsResponse, APIError>
}

extension RecommendationsService {
    func get(_ country: Country) -> AnyPublisher<RecommendationsResponse, APIError> {
        return session.request(with: RecommendationsEndpoint.get(country))
            .eraseToAnyPublisher()
    }
}
