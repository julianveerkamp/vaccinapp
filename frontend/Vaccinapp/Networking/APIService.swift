//
//  APIService.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 27.05.22.
//

import Foundation
import Combine

enum APIData {
    static let baseUrl: String = "https://adq7tbsjf4.execute-api.us-east-1.amazonaws.com"
}

protocol APIService {
    func request<T: Decodable>(with builder: RequestBuilder) -> AnyPublisher<T, APIError>
}

protocol RequestBuilder {
    var urlRequest: URLRequest {get}
}

enum APIError: Error {
    case decodingError(Error)
    case httpError(Int, String)
    case unknown
}

struct ErrorMessageDTO: Codable {
    let message: String
}
