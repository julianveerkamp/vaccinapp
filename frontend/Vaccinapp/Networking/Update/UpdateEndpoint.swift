//
//  UpdateEndpoint.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 03.06.22.
//

import Foundation

enum UpdateEndpoint {
    case update
}

extension UpdateEndpoint: RequestBuilder {
    var urlRequest: URLRequest {
        switch self {
        case .update:
            guard let url = URL(string: "\(APIData.baseUrl)/update")
            else { preconditionFailure("Invalid URL format")}
            
            return URLRequest(url: url)
        }
    }
}
