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
    }
    
    struct Output {
        let imagesDataSource: PassthroughSubject<[Image], Never>
    }
    
    private var page = 1
    private var hasMoreImages = true
    
    private let imagesDataSource = PassthroughSubject<[Image], Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let networkService: ImagesListNetworkServiceProtocol
    
    init(networkService: ImagesListNetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        cancellables.addElements(
            imagesFetchObserving(with: input.imagesFetchSignal)
        )
        
        let output = Output(
            imagesDataSource: imagesDataSource
        )
        
        outputHandler(output)
    }
    
    private func imagesFetchObserving(with signal: PassthroughSubject<Void, Never>) -> AnyCancellable {
        signal
            .sink { [weak self] _ in
                guard let self, hasMoreImages else { return }
                networkService.getImagesList(with: page)
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { completion in
                        if case let .failure(error) = completion {
                            debugPrint(error)
                        }
                    }, receiveValue: { [weak self] images in
                        guard let self else { return }
                        hasMoreImages = images.count == NetworkConstants.perPage
                        page += 1
                        imagesDataSource.send(images)
                    })
                    .store(in: &cancellables)
            }
    }
}
