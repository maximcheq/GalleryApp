//
//  Image.swift
//  GalleryApp
//
//  Created by Maksim Kuklitski on 28.03.24.
//

import Foundation

struct Image: Decodable, Hashable {
    let id: String
    let description: String?
    let urls: Urls
    let user: User
    let likes: Int
    
    struct Urls: Decodable, Hashable {
        let thumb: String
    }
    
    struct User: Decodable, Hashable {
        let username: String
    }
}

extension Image {
    init(object: ImageObject) {
        id = object.id
        description = object.descriptionText
        urls = Urls(thumb: object.thumbURL)
        user = User(username: object.username)
        likes = object.likes
    }
}

