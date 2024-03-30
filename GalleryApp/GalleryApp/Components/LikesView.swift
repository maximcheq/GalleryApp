//
//  LikesView.swift
//  GalleryApp
//
//  Created by Maksim Kuklitski on 29.03.24.
//

import UIKit

final class LikesView: UIView {
    
    private let amountLabel = GalleryTitleLabel(textAlignment: .left, fontSize: 14)
    private let likeImageView = UIImageView(image: .isNotFavoriteButton)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(amount: Int) {
        amountLabel.text = String(amount)
    }
    
    private func configure() {
        addSubviews(likeImageView, amountLabel)
                
        likeImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(4)
            make.size.equalTo(30)
            make.centerY.equalToSuperview()
        }
        
        amountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(likeImageView.snp.centerY)
            make.leading.equalTo(likeImageView.snp.trailing).offset(4)
            make.trailing.equalToSuperview()
        }
    }
}
