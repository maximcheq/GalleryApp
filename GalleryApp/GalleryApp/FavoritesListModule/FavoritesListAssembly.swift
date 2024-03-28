//
//  FavoritesListAssembly.swift
//  GalleryApp
//
//  Created by Maksim Kuklitski on 28.03.24.
//

import UIKit

final class FavoritesListAssembly {
    static func make() -> UIViewController {
        let viewController = FavoritesListViewController()
        //let router = SearchRouter(rootView: viewController)
        //let viewModel = SearchViewModel(router: router)
        
        //viewController.viewModel = viewModel
        
        return viewController
    }
}
