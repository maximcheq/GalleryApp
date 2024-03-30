//
//  FavoritesListRouter.swift
//  GalleryApp
//
//  Created by Maksim Kuklitski on 28.03.24.
//

import UIKit

protocol FavoritesListRouterProtocol {
    func openDetailedImageScreen(with images: [Image], index: Int)
}

final class FavoritesListRouter: FavoritesListRouterProtocol {
    
    var navigationController: UINavigationController? {
        rootView?.navigationController
    }

    weak var rootView: UIViewController?

    init(rootView: UIViewController) {
        self.rootView = rootView
    }
        
    func openDetailedImageScreen(with images: [Image], index: Int) {
        let viewController = DetailedImageAssembly.make(with: images, index: index)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
