//
//  ImagesListViewModel.swift
//  GalleryApp
//
//  Created by Maksim Kuklitski on 28.03.24.
//

import Foundation
import Combine

final class ImagesListViewModel {
    struct Input {
        let imagesFetchSignal: PassthroughSubject<Void, Never>
        let favoritesFetchSignal: PassthroughSubject<Void, Never>
        let didTapFavoriteSignal: PassthroughSubject<(Bool, Image), Never>
    }
    
    struct Output {
        let imagesDataSource: PassthroughSubject<[Image], Never>
        let favoritesDataSource: PassthroughSubject<[Image], Never>
        let loadingIndicatorDataSource: PassthroughSubject<Bool, Never>
    }
    
    private var page = 1
    private var hasMoreImages = true
    
    private let loadingIndicatorDataSource = PassthroughSubject<Bool, Never>()
    private let imagesDataSource = PassthroughSubject<[Image], Never>()
    private let favoritesDataSource = PassthroughSubject<[Image], Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let networkService: ImagesListNetworkServiceProtocol
    private let imageRepository: ImageRepository
    
    init(networkService: ImagesListNetworkServiceProtocol,
         imageRepository: ImageRepository) {
        self.networkService = networkService
        self.imageRepository = imageRepository
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        cancellables.addElements(
            imagesFetchObserving(with: input.imagesFetchSignal),
            favoritesFetchObserving(with: input.favoritesFetchSignal),
            didTapFavoriteObserving(with: input.didTapFavoriteSignal)
        )
        
        let output = Output(
            imagesDataSource: imagesDataSource, 
            favoritesDataSource: favoritesDataSource, 
            loadingIndicatorDataSource: loadingIndicatorDataSource
        )
        
        outputHandler(output)
    }
    
    private func imagesFetchObserving(with signal: PassthroughSubject<Void, Never>) -> AnyCancellable {
        signal
            .sink { [weak self] _ in
                guard let self, hasMoreImages else { return }
                loadingIndicatorDataSource.send(true)
                networkService.getImagesList(with: page)
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { [weak self] completion in
                        guard let self else { return }
                        if case let .failure(error) = completion {
                            debugPrint(error)
                        }
                        loadingIndicatorDataSource.send(false)
                    }, receiveValue: { [weak self] images in
                        guard let self else { return }
                        hasMoreImages = images.count == NetworkConstants.perPage
                        page += 1
                        imagesDataSource.send(images)
                    })
                    .store(in: &cancellables)
            }
    }
    
    private func didTapFavoriteObserving(with signal: PassthroughSubject<(Bool, Image), Never>) -> AnyCancellable {
        signal
            .sink { [weak self] isFavorite, image in
                guard let self else { return }
                if !isFavorite {
                    imageRepository.removeImage(image.id)
                } else {
                    imageRepository.addImage(image)
                }
            }
    }
    
    private func favoritesFetchObserving(with signal: PassthroughSubject<Void, Never>) -> AnyCancellable {
        signal
            .sink { [weak self] _ in
                guard let self else { return }
                let favorites = imageRepository.getImagesList()
                favoritesDataSource.send(favorites)
            }
    }
}
