//
//  ImagesListViewModel.swift
//  GalleryApp
//
//  Created by Maksim Kuklitski on 28.03.24.
//

import Foundation
import Combine

final class ImagesListViewModel {
    struct Input {}
    
    struct Output {}
    
    private var cancellables = Set<AnyCancellable>()
    
    private let networkService: ImagesListNetworkServiceProtocol
    
    init(networkService: ImagesListNetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        cancellables.addElements(
            openFollowersListObserving(with: input.openFollowersListSignal),
            presentGFAlertObserving(with: input.presentGFAlertSignal)
        )
        
        let output = Output()
        
        outputHandler(output)
    }
}
