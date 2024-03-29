//
//  ImageCell.swift
//  GalleryApp
//
//  Created by Maksim Kuklitski on 28.03.24.
//

import UIKit
import Kingfisher
import SnapKit

final class ImageCell: UICollectionViewCell {
    private enum Constants {
        static let imageViewPadding: CGFloat = 8
        static let buttonPadding: CGFloat = 16
        static let buttonSize: CGFloat = 32
    }
    
    static let reuseID = String(describing: ImageCell.self)
    
    private let avatarImageView = GalleryImageView(frame: .zero)
    private lazy var favoriteButton: FavoriteButton = {
        let button = FavoriteButton()
        button.isFavorite = false
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var action: ((Bool) -> Void)?
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let buttonPoint = convert(point, to: favoriteButton)
        if favoriteButton.bounds.contains(buttonPoint) {
            return favoriteButton
        }
        return super.hitTest(point, with: event)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(image: Image, favorites: [Image]) {
        let url = URL(string: image.urls.thumb)
        avatarImageView.kf.setImage(with: url)
        favoriteButton.isFavorite = favorites.map { $0.id }.contains(image.id)
    }
    
    @objc private func favoriteButtonTapped() {
        action?(favoriteButton.isFavorite)
        favoriteButton.isFavorite.toggle()
    }
    
    private func configure() {
        addSubview(avatarImageView)
        avatarImageView.addSubview(favoriteButton)
 
        avatarImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(Constants.imageViewPadding)
            make.height.equalTo(avatarImageView.snp.width)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Constants.buttonPadding)
            make.top.equalToSuperview().inset(Constants.buttonPadding)
            make.size.equalTo(Constants.buttonSize)
        }
    }
}
