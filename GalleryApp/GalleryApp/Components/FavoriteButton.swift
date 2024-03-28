//
//  FavoriteButton.swift
//  GalleryApp
//
//  Created by Maksim Kuklitski on 28.03.24.
//

import UIKit

public final class FavouriteButton: UIButton {
    
    public var isFavourite = false {
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
        if isFavourite {
            backgroundColor = .systemPink
            setImage(.isFavouriteButton, for: .normal)
        } else {
            backgroundColor = .white
            setImage(.isNotFavouriteButton.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
}
