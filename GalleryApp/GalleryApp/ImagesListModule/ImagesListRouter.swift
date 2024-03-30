//
//  ImagesListRouter.swift
//  GalleryApp
//
//  Created by Maksim Kuklitski on 28.03.24.
//

import UIKit

protocol ImagesListRouterProtocol {
    func openDetailedImageScreen(with images: [Image], index: Int)
    func presentErrorAlert(with title: String, message: String, action: @escaping () -> Void) 
}

final class ImagesListRouter: ImagesListRouterProtocol {
    
    var navigationController: UINavigationController? {
        rootView?.navigationController
    }

    weak var rootView: UIViewController?

    init(rootView: UIViewController) {
        self.rootView = rootView
    }
    
    func presentErrorAlert(with title: String, message: String, action: @escaping () -> Void) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "Retry", style: .default) { _ in
            action()
        }
        alertController.addAction(retryAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        rootView?.present(alertController, animated: true)
    }
        
    func openDetailedImageScreen(with images: [Image], index: Int) {
        let viewController = DetailedImageAssembly.make(with: images, index: index)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
