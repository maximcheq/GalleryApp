//
//  ImagesListNetworkService.swift
//  GalleryApp
//
//  Created by Maksim Kuklitski on 28.03.24.
//

import Foundation
import Combine

protocol ImagesListNetworkServiceProtocol: AnyObject {
    typealias ImagesList = AnyPublisher<[Image], NetworkError>
    
    func getImagesList(with page: Int) -> ImagesList
}

final class ImagesListNetworkService: ImagesListNetworkServiceProtocol {
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func getImagesList(with page: Int) -> ImagesList {
        let endpoint = ImagesListEndpoint.getImagesList(page: page)
        let publisher: ImagesList = apiService.request(endpoint)
        return publisher
            .catch { error -> ImagesList in
                return Fail(error: error).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
