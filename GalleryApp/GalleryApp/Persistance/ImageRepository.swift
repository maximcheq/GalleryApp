//
//  ImageRepository.swift
//  GalleryApp
//
//  Created by Maksim Kuklitski on 28.03.24.
//

import Foundation
import RealmSwift

protocol ImageRepository {
    func getImagesList() -> [Image]
    func removeImage(_ id: String)
    func addImage(_ data: Image)
}

final class ImageRepositoryImpl: ImageRepository {
    private let storage: StorageService
    
    init(storage: StorageService = StorageService()) {
        self.storage = storage
    }
    
    func getImagesList() -> [Image] {
        let data = storage.fetch(by: ImageObject.self)
        return data.map(Image.init)
    }
    
    func removeImage(_ id: String) {
        try? storage.delete(id: id)
    }
    
    func addImage(_ data: Image) {
        let object = ImageObject(data)
        try? storage.saveOrUpdateObject(object: object)
    }
}
