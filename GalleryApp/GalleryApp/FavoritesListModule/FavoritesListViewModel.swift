//
//  FavoritesListViewModel.swift
//  GalleryApp
//
//  Created by Maksim Kuklitski on 28.03.24.
//

import Foundation
import Combine

final class FavoritesListViewModel {
    struct Input {
        let favoritesFetchSignal: PassthroughSubject<Void, Never>
        let deleteFavoriteSignal: PassthroughSubject<Image, Never>
        let didSelectFavorite: PassthroughSubject<([Image], Int), Never>
    }
    
    struct Output {
        let favoritesDataSource: PassthroughSubject<[Image], Never>
    }
    
    private let favoritesDataSource = PassthroughSubject<[Image], Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let imageRepository: ImageRepository
    private let router: FavoritesListRouterProtocol
    
    init(imageRepository: ImageRepository,
         router: FavoritesListRouterProtocol) {
        self.imageRepository = imageRepository
        self.router = router
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        cancellables.addElements(
            favoritesFetchObserving(with: input.favoritesFetchSignal),
            deleteFavoriteObserving(with: input.deleteFavoriteSignal),
            didSelectFavoriteObserving(with: input.didSelectFavorite)
        )
        
        let output = Output(
            favoritesDataSource: favoritesDataSource
        )
        
        outputHandler(output)
    }
    
    private func favoritesFetchObserving(with signal: PassthroughSubject<Void, Never>) -> AnyCancellable {
        signal
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                let favorites = imageRepository.getImagesList()
                favoritesDataSource.send(favorites)
            }
    }
    
    private func deleteFavoriteObserving(with signal: PassthroughSubject<Image, Never>) -> AnyCancellable {
        signal
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                guard let self else { return }
                imageRepository.removeImage(image.id)
            }
    }
    
    private func didSelectFavoriteObserving(with signal: PassthroughSubject<([Image], Int), Never>) -> AnyCancellable {
        signal
            .receive(on: DispatchQueue.main)
            .sink { [weak self] images, index in
                guard let self else { return }
                router.openDetailedImageScreen(with: images, index: index)
            }
    }
}
