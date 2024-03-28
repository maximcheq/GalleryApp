//
//  LoadingIndicatorView.swift
//  GalleryApp
//
//  Created by Maksim Kuklitski on 28.03.24.
//

import UIKit
import SnapKit

final class LoadingIndicatorView: UIView {
    
    private lazy var activityIndicator = UIActivityIndicatorView(style: .large)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    override func didMoveToSuperview() {
        if superview != nil {
            setupView()
        }
        super.didMoveToSuperview()
    }
    
    private func commonInit() {
        alpha = 0.0
        isHidden = true
        
        layer.cornerRadius = 8
        layer.masksToBounds = true
        backgroundColor = .systemBackground
    }
    
    private func setupView() {
        addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func showProgress(animated: Bool = true) {
        guard isHidden else { return }
        
        isHidden = false
        activityIndicator.startAnimating()
        UIView.animate(withDuration: animated ? 0.25 : 0.0) {
            self.alpha = 0.8
        }
    }
    
    func hideProgress(animated: Bool = true) {
        guard !isHidden else { return }
        
        UIView.animate(withDuration: animated ? 0.25 : 0.0, animations: {
            self.alpha = 0.0
        }) { _ in
            self.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }
    
    func show(_ isLoading: Bool, animated: Bool = true) {
        isLoading ? showProgress() : hideProgress()
    }
}
