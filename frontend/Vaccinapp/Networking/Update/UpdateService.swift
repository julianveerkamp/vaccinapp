//
//  UpdateService.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 03.06.22.
//

import Foundation
import Combine

protocol UpdateService {
    var session: APIService {get}
    
    func update() -> AnyPublisher<UpdateResponse, APIError>
}

extension UpdateService {
    func update() -> AnyPublisher<UpdateResponse, APIError> {
        return session.request(with: UpdateEndpoint.update)
            .eraseToAnyPublisher()
    }
}
