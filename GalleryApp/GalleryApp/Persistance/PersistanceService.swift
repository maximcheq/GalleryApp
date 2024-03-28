//
//  PersistanceService.swift
//  GalleryApp
//
//  Created by Maksim Kuklitski on 28.03.24.
//

import Foundation
import RealmSwift

final class StorageService {
    private let storage: Realm?
    
    init() {
        self.storage = try? Realm()
    }
    
    func saveOrUpdateObject(object: Object) throws {
        guard let storage else { return }
        storage.writeAsync {
            storage.add(object, update: .all)
        }
    }
    
    func saveOrUpdateAllObjects(objects: [Object]) throws {
        try objects.forEach {
            try saveOrUpdateObject(object: $0)
        }
    }
    
    func delete(id: String) throws {
        guard let storage else { return }
        if let objectToDelete = storage.object(ofType: ImageObject.self, forPrimaryKey: id) {
            storage.writeAsync {
                storage.delete(objectToDelete)
            }
        }
    }
    
    func deleteAll() throws {
        guard let storage else { return }
        try storage.write {
            storage.deleteAll()
        }
    }
    
    func fetch<T: Object>(by type: T.Type) -> [T] {
        guard let storage else { return [] }
        return storage.objects(T.self).toArray()
    }
}

extension Results {
    func toArray() -> [Element] {
        .init(self)
    }
}
