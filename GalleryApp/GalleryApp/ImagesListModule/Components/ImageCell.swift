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
        static let padding: CGFloat = 8
    }
    
    static let reuseID = String(describing: ImageCell.self)
    
    private let avatarImageView = GalleryImageView(frame: .zero)
    private lazy var favoriteButton: FavouriteButton = {
        let button = FavouriteButton()
        button.isFavourite = false
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var action: ((Bool) -> ())?
    
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
        favoriteButton.isFavourite = favorites.map { $0.id }.contains(image.id)
    }
    
    @objc private func favoriteButtonTapped() {
        favoriteButton.isFavourite.toggle()
        action?(favoriteButton.isFavourite)
    }
    
    private func configure() {
        addSubview(avatarImageView)
        avatarImageView.addSubview(favoriteButton)
 
        avatarImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(Constants.padding)
            make.height.equalTo(avatarImageView.snp.width)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(16)
            make.size.equalTo(32)
        }
    }
}
