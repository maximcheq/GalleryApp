//
//  BaseEndpoint.swift
//  GalleryApp
//
//  Created by Maksim Kuklitski on 28.03.24.
//

import Foundation

enum HTTPMethod {
    case get
    
    public var rawValue: String {
        switch self {
        case .get:
            return "GET"
        }
    }
}

protocol Endpoint {
    var baseURL: URL { get }

    var path: String { get }

    var httpMethod: HTTPMethod { get }

    var headers: [String: String]? { get }

    var parameters: [String: Any]? { get }

    var decoder: JSONDecoder { get }
}
