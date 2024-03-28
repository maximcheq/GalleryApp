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
        let thumb: URL
    }
    
    struct User: Decodable, Hashable {
        let username: String
    }
}

