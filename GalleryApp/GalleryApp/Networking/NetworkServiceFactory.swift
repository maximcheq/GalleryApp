//
//  NetworkServiceFactory.swift
//  GalleryApp
//
//  Created by Maksim Kuklitski on 28.03.24.
//

import Foundation

protocol NetworkingServiceFactoryProtocol: AnyObject {
    func makeImagesListService() -> ImagesListNetworkServiceProtocol
}

final class NetworkServiceFactory: NetworkingServiceFactoryProtocol {
    static let shared = NetworkServiceFactory()
    
    private let apiService: APIServiceProtocol = APIService.instance
        
    private init() {}
        
    func makeImagesListService() -> ImagesListNetworkServiceProtocol {
        ImagesListNetworkService(apiService: apiService)
    }
    
    
}
