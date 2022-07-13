//
//  RecommendationsEndpoint.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 27.05.22.
//

import Foundation

enum RecommendationsEndpoint {
    case get(Country)
}

extension RecommendationsEndpoint: RequestBuilder {
    var urlRequest: URLRequest {
        switch self {
        case .get(let country):
            guard let url = URL(string: "\(APIData.baseUrl)/recommend/\(country.rawValue.lowercased())")
            else { preconditionFailure("Invalid URL format")}
            
            return URLRequest(url: url)
        }
    }
}
