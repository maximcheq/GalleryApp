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
        //let router = SearchRouter(rootView: viewController)
        let viewModel = ImagesListViewModel(networkService: networkService)
        
        viewController.viewModel = viewModel
        
        return viewController
    }
}
