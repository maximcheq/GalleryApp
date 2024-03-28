//
//  Image.swift
//  GalleryApp
//
//  Created by Maksim Kuklitski on 28.03.24.
//

import Foundation

struct Image: Decodable {
    let id: Int
    let title, description: String
    let coverPhoto: CoverPhoto
    
    struct CoverPhoto: Decodable {
        let urls: Urls
        
        struct Urls: Decodable {
            let regular: URL
        }
    }
}

