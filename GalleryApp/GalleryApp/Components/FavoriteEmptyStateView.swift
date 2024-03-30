//
//  FavoriteEmptyStateView.swift
//  GalleryApp
//
//  Created by Maksim Kuklitski on 30.03.24.
//

import UIKit

final class FavoriteEmptyStateView: UIView {
    
    private enum Constants {
        static let titleText = "No favorites"
        static let descriptionText = "Add favorites in the images list screen"
    }
    
    private let imageView = UIImageView()
    private let titleLabel = GalleryTitleLabel(textAlignment: .center, fontSize: 25)
    private let descriptionLabel = GalleryDescriptionLabel(textAlignment: .center)
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(stackView)
        stackView.addArrangedSubviews(imageView, titleLabel, descriptionLabel)
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        
        imageView.image = UIImage(systemName: SFSymbols.star)
        imageView.tintColor = .secondaryLabel
        imageView.contentMode = .scaleAspectFill
        
        titleLabel.text = Constants.titleText
        descriptionLabel.text = Constants.descriptionText
        
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(60)
        }
    }
}
