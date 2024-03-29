//
//  FavoriteButton.swift
//  GalleryApp
//
//  Created by Maksim Kuklitski on 28.03.24.
//

import UIKit

public final class FavoriteButton: UIButton {
    
    public var isFavorite = false {
        didSet {
            updateButtonAppearance()
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = 16
        backgroundColor = .white
        tintColor = .black
        imageView?.contentMode = .scaleAspectFit
        imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func updateButtonAppearance() {
        if isFavorite {
            backgroundColor = .systemPink
            setImage(.isFavoriteButton, for: .normal)
        } else {
            backgroundColor = .white
            setImage(.isNotFavoriteButton.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
}
