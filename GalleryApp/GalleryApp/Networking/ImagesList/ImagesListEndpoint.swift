//
//  ImagesListEndpoint.swift
//  GalleryApp
//
//  Created by Maksim Kuklitski on 28.03.24.
//

import Foundation

enum ImagesListEndpoint {
    case getImagesList(page: Int)
}

extension ImagesListEndpoint: Endpoint {
    var baseURL: URL {
        guard let url = URL(string: NetworkConstants.baseURL) else {
            fatalError("Failed attempt to use provider base URL! \(NetworkConstants.baseURL)")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getImagesList:
            return "/photos"
        }
    }
    
    var httpMethod: HTTPMethod {
        .get
    }
    
    var headers: [String: String]? {
        switch self {
        case .getImagesList:
            ["Authorization": "Client-ID " + NetworkConstants.accessKey ]
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getImagesList(let page):
            ["per_page": NetworkConstants.perPage,
             "page": page]
        }
    }
    
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
