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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(image: Image) {
        let url = image.urls.thumb
        avatarImageView.kf.setImage(with: url)
    }
    
    private func configure() {
        addSubview(avatarImageView)
 
        avatarImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(Constants.padding)
            make.height.equalTo(avatarImageView.snp.width)
        }
    }
}
