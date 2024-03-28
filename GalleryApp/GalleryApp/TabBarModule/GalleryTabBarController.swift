//
//  GalleryTabBarController.swift
//  GalleryApp
//
//  Created by Maksim Kuklitski on 28.03.24.
//

import UIKit

final class GalleryTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
    }
    
    private func createImagesNavigationController() -> UINavigationController {
        let searchViewController = ImagesListAssembly.make()
        searchViewController.title = "Images"
        searchViewController.tabBarItem = UITabBarItem(title: "Images", image: .init(systemName: "photo"), tag: 0)
        
        return UINavigationController(rootViewController: searchViewController)
    }
    
    private func createFavoritesListNavigationController() -> UINavigationController {
        let favoritesListViewController = FavoritesListAssembly.make()
        favoritesListViewController.title = "Favorites"
        favoritesListViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        return UINavigationController(rootViewController: favoritesListViewController)
    }
    
    private func configureViewControllers() {
        viewControllers = [createImagesNavigationController(), createFavoritesListNavigationController()]
    }
}
