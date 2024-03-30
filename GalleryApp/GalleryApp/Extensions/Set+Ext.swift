//
//  Set+Ext.swift
//  GalleryApp
//
//  Created by Maksim Kuklitski on 28.03.24.
//

import Foundation

extension Set {
    mutating func addElements(_ elements: Element...) {
        elements.forEach { insert($0) }
    }
}
