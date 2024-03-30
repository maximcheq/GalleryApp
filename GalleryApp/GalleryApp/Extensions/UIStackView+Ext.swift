//
//  UIStackView+Ext.swift
//  GalleryApp
//
//  Created by Maksim Kuklitski on 29.03.24.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { addArrangedSubview($0) }
    }
}
