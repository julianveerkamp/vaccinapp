//
//  APISession.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 27.05.22.
//

import Foundation
import Combine


struct APISession: APIService {
    func request<T>(with: RequestBuilder) -> AnyPublisher<T, APIError> where T : Decodable {
        return URLSession.shared
            .dataTaskPublisher(for: with.urlRequest)
            .receive(on: DispatchQueue.main)
            .mapError {_ in .unknown}
            .flatMap { data, response -> AnyPublisher<T, APIError> in
                if let response = response as? HTTPURLResponse {
                    if (200...299).contains(response.statusCode) || response.statusCode == 304 {
                        return Just(data)
                            .decode(type: T.self, decoder: JSONDecoder())
                            .mapError { e in .decodingError(e)}
                            .eraseToAnyPublisher()
                    } else {
                        do {
                            let message = try JSONDecoder().decode(ErrorMessageDTO.self, from: data)
                            return Fail(error: APIError.httpError(response.statusCode, message.message))
                                .eraseToAnyPublisher()
                        } catch {
                            return Fail(error: APIError.unknown)
                                .eraseToAnyPublisher()
                        }
                    }
                }
                return Fail(error: APIError.unknown)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
