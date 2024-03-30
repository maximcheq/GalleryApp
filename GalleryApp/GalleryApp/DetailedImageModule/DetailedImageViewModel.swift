//
//  DetailedImageViewModel.swift
//  GalleryApp
//
//  Created by Maksim Kuklitski on 29.03.24.
//

import Foundation
import Combine

final class DetailedImageViewModel {
    struct Input {
        let imageFetchSignal: PassthroughSubject<Void, Never>
        let didSwipeSignal: PassthroughSubject<SwipeDirection, Never>
    }
    
    struct Output {
        let imageDataSource: PassthroughSubject<Image, Never>
    }
    
    private let imageDataSource = PassthroughSubject<Image, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private var index: Int
    private let images: [Image]
    
    init(index: Int, images: [Image]) {
        self.index = index
        self.images = images
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        cancellables.addElements(
            imageFetchObserving(with: input.imageFetchSignal),
            didSwipeObserving(with: input.didSwipeSignal)
        )
        
        let output = Output(
            imageDataSource: imageDataSource
        )
        
        outputHandler(output)
    }
    
    private func imageFetchObserving(with signal: PassthroughSubject<Void, Never>) -> AnyCancellable {
        signal
            .sink { [weak self] _ in
                guard let self else { return }
                let image = images[index]
                imageDataSource.send(image)
            }
    }
    
    private func didSwipeObserving(with signal: PassthroughSubject<SwipeDirection, Never>) -> AnyCancellable {
        signal
            .sink { [weak self] direction in
                guard let self else { return }
                switch direction {
                case .up:
                    guard index < images.count - 1 else { return }
                    index += 1
                case .down:
                    guard index > 0 else { return }
                    index -= 1
                }
                
                let image = images[index]
                imageDataSource.send(image)
            }
    }
}
