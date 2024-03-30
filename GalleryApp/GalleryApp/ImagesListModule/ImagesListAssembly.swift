//
//  ImagesListAssembly.swift
//  GalleryApp
//
//  Created by Maksim Kuklitski on 28.03.24.
//

import UIKit

final class ImagesListAssembly {
    static func make() -> UIViewController {
        let viewController = ImagesListViewController()
        let networkService = NetworkServiceFactory.shared.makeImagesListService()
        let router = ImagesListRouter(rootView: viewController)
        let imageRepository = ImageRepositoryImpl()
        let viewModel = ImagesListViewModel(networkService: networkService,
                                            imageRepository: imageRepository, 
                                            router: router)
        
        viewController.viewModel = viewModel
        
        return viewController
    }
}
