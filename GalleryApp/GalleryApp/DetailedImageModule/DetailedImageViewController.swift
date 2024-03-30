//
//  DetailedImageViewController.swift
//  GalleryApp
//
//  Created by Maksim Kuklitski on 29.03.24.
//

import UIKit
import SnapKit
import Kingfisher
import Combine

enum SwipeDirection {
    case up, down
}

final class DetailedImageViewController: UIViewController {
    
    private enum Constants {
        static let noDescriptionMock = "The author didn't add any description."
        static let padding: CGFloat = 20
        static let imageViewHeight: CGFloat = 200
        static let likesViewWidth: CGFloat = 70
    }
    
    private let avatarImageView = GalleryImageView(frame: .zero)
    private let authorLabel = GalleryTitleLabel(textAlignment: .left, fontSize: 32)
    private let descriptionLabel = GalleryDescriptionLabel(textAlignment: .left)
    private let likesView = LikesView()
    private let stackView = UIStackView()
    
    private let didSwipeSignal = PassthroughSubject<SwipeDirection, Never>()
    private let imageFetchSignal = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // swiftlint:disable implicitly_unwrapped_optional
    var viewModel: DetailedImageViewModel!
    // swiftlint:enable implicitly_unwrapped_optional
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupViews()
        setupGestures()
        
        imageFetchSignal.send()
    }
    
    private func bindViewModel() {
        let input = DetailedImageViewModel.Input(
            imageFetchSignal: imageFetchSignal, 
            didSwipeSignal: didSwipeSignal
        )
        
        viewModel.transform(input, outputHandler: handleOutput)
    }
    
    private func handleOutput(_ output: DetailedImageViewModel.Output) {
        cancellables.addElements(
            updateView(with: output.imageDataSource)
        )
    }
    
    private func updateView(with signal: PassthroughSubject<Image, Never>) -> AnyCancellable {
        signal
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                guard let self else { return }
                configure(with: image)
            }
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubviews(avatarImageView, stackView, descriptionLabel)
        stackView.addArrangedSubviews(authorLabel, likesView)
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        
        authorLabel.numberOfLines = 2
        descriptionLabel.numberOfLines = 0
        
        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(Constants.padding)
            make.height.equalTo(Constants.imageViewHeight)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(Constants.padding)
            make.leading.trailing.equalToSuperview().inset(Constants.padding)
        }
        
        likesView.snp.makeConstraints { make in
            make.width.equalTo(Constants.likesViewWidth)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(Constants.padding)
            make.leading.trailing.equalToSuperview().inset(Constants.padding)
        }
    }
    
    private func configure(with image: Image) {
        let url = URL(string: image.urls.regular)
        avatarImageView.kf.setImage(with: url)
        authorLabel.text = "Shoot by " + image.user.username
        descriptionLabel.text = image.description ?? Constants.noDescriptionMock
        likesView.set(amount: image.likes)
    }
    
    private func setupGestures() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }
    
    @objc private func handleSwipe(sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .up:
            didSwipeSignal.send(.up)
        case .down:
            didSwipeSignal.send(.down)
        default:
            break
        }
    }
}
