//
//  FavoriteCell.swift
//  GalleryApp
//
//  Created by Maksim Kuklitski on 29.03.24.
//

import UIKit
import Kingfisher

final class FavoriteCell: UITableViewCell {
    private enum Constants {
        static let padding: CGFloat = 12
        static let labelLeadingPadding: CGFloat = 24
        static let labelLHeight: CGFloat = 40
        static let imageViewSize: CGFloat = 60
    }
    
    static let reuseID = String(describing: FavoriteCell.self)
    
    private let avatarImageView = GalleryImageView(frame: .zero)
    private let usernameLabel = GalleryTitleLabel(textAlignment: .left, fontSize: 26)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(favorite: Image) {
        let url = URL(string: favorite.urls.thumb)
        avatarImageView.kf.setImage(with: url)
        usernameLabel.text = "by " + favorite.user.username
    }
    
    private func configure() {
        addSubviews(avatarImageView, usernameLabel)
        
        accessoryType = .disclosureIndicator
        selectionStyle = .none
        
        avatarImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(Constants.padding)
            make.size.equalTo(Constants.imageViewSize)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(avatarImageView.snp.trailing).offset(Constants.labelLeadingPadding)
            make.trailing.equalToSuperview().inset(Constants.padding)
            make.height.equalTo(Constants.labelLHeight)
        }
    }
}
