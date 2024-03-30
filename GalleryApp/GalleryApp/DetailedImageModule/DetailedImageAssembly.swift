//
//  DetailedImageAssembly.swift
//  GalleryApp
//
//  Created by Maksim Kuklitski on 29.03.24.
//

import UIKit

final class DetailedImageAssembly {
    static func make(with images: [Image], index: Int) -> UIViewController {
        let viewController = DetailedImageViewController()
        let viewModel = DetailedImageViewModel(index: index, images: images)
        
        viewController.viewModel = viewModel
        
        return viewController
    }
}
