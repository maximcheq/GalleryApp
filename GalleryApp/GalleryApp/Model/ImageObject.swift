//
//  ImageObject.swift
//  GalleryApp
//
//  Created by Maksim Kuklitski on 28.03.24.
//

import Foundation
import RealmSwift

final class ImageObject: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var descriptionText: String?
    @Persisted var thumbURL: String
    @Persisted var regularURL: String
    @Persisted var username: String
    @Persisted var likes: Int
    
    convenience init(
        id: String,
        descriptionText: String?,
        thumbURL: String,
        username: String,
        likes: Int
    ) {
        self.init()
        self.id = id
        self.descriptionText = descriptionText
        self.thumbURL = thumbURL
        self.username = username
        self.likes = likes
    }
}

extension ImageObject {
    convenience init(_ dto: Image) {
        self.init()
        id = dto.id
        descriptionText = dto.description
        thumbURL = dto.urls.thumb
        regularURL = dto.urls.regular
        username = dto.user.username
        likes = dto.likes
    }
}
