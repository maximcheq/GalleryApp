//
//  ImagesListViewController.swift
//  GalleryApp
//
//  Created by Maksim Kuklitski on 28.03.24.
//

import UIKit
import Combine

final class ImagesListViewController: UIViewController {
    
    private enum Constants {
        static let padding: CGFloat = 12
        static let minimumItemSpacing: CGFloat = 10
    }
    
    private enum Section {
        case main
    }
    
    private lazy var collectionView = UICollectionView(frame: view.bounds,
                                                       collectionViewLayout: createTwoColumnFlowLayout())
    // swiftlint:disable line_length
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Image> = .init(collectionView: collectionView) { collectionView, indexPath, image in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseID, for: indexPath) as? ImageCell else {
            return UICollectionViewCell()
        }
        
        cell.action = { [weak self] isFavorite in
            self?.didTapFavoriteSignal.send((isFavorite, image))
        }
        
        cell.set(image: image, favorites: self.favoritesDataSource)
        return cell
    }
    // swiftlint:enable line_length
    
    private let loadingIndicator = LoadingIndicatorView()
    
    private var imagesDataSource: [Image] = []
    private var favoritesDataSource: [Image] = []
    
    private let imagesFetchSignal = PassthroughSubject<Void, Never>()
    private let favoritesFetchSignal = PassthroughSubject<Void, Never>()
    private let didTapFavoriteSignal = PassthroughSubject<(Bool, Image), Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // swiftlint:disable implicitly_unwrapped_optional
    var viewModel: ImagesListViewModel!
    // swiftlint:enable implicitly_unwrapped_optional

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureView()
        configureCollectionView()
        configureLoadingIndicator()
        
        imagesFetchSignal.send()
        favoritesFetchSignal.send()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoritesFetchSignal.send()
    }
    
    private func bindViewModel() {
        let input = ImagesListViewModel.Input(
            imagesFetchSignal: imagesFetchSignal, 
            favoritesFetchSignal: favoritesFetchSignal,
            didTapFavoriteSignal: didTapFavoriteSignal
        )
        
        viewModel.transform(input, outputHandler: handleOutput)
    }
    
    private func handleOutput(_ output: ImagesListViewModel.Output) {
        cancellables.addElements(
            updateImagesDataSource(with: output.imagesDataSource),
            updateLoadingIndicator(with: output.loadingIndicatorDataSource),
            updateFavoritesDataSource(with: output.favoritesDataSource)
        )
    }
    
    private func updateImagesDataSource(with signal: PassthroughSubject<[Image], Never>) -> AnyCancellable {
        signal
            .receive(on: DispatchQueue.main)
            .sink { [weak self] images in
                guard let self else { return }
                imagesDataSource.append(contentsOf: images)
                updateData()
            }
    }
    
    private func updateFavoritesDataSource(with signal: PassthroughSubject<[Image], Never>) -> AnyCancellable {
        signal
            .receive(on: DispatchQueue.main)
            .sink { [weak self] favorites in
                guard let self else { return }
                favoritesDataSource = favorites
                collectionView.reloadData()
            }
    }
    
    private func updateLoadingIndicator(with signal: PassthroughSubject<Bool, Never>) -> AnyCancellable {
        signal
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isShown in
                isShown ? self?.loadingIndicator.showProgress() : self?.loadingIndicator.hideProgress()
            }
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseID)
    }
    
    private func configureLoadingIndicator() {
        view.addSubview(loadingIndicator)
        
        loadingIndicator.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Image>()
        snapshot.appendSections([.main])
        snapshot.appendItems(imagesDataSource)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func createTwoColumnFlowLayout() -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = Constants.padding
        let minimumItemSpacing: CGFloat = Constants.minimumItemSpacing
        let availableWidth = width - (padding * 2) - (minimumItemSpacing)
        let itemWidth = availableWidth / 2
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        return flowLayout
    }
}

extension ImagesListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard indexPath.row == imagesDataSource.count - 1 else { return }
        
        imagesFetchSignal.send()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("tapped")
    }
}
