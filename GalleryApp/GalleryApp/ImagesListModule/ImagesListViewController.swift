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
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Image> = .init(collectionView: collectionView) { collectionView, indexPath, image in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseID, for: indexPath) as? ImageCell else { return UICollectionViewCell() }

        cell.set(image: image)
        return cell
    }
    
    private let loadingIndicator = LoadingIndicatorView()
    
    private var imagesDataSource: [Image] = []
    
    private let imagesFetchSignal = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    var viewModel: ImagesListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureView()
        configureCollectionView()
        configureLoadingIndicator()
        
        imagesFetchSignal.send()
    }
    
    private func bindViewModel() {
        let input = ImagesListViewModel.Input(
            imagesFetchSignal: imagesFetchSignal
        )
        
        viewModel.transform(input, outputHandler: handleOutput)
    }
    
    private func handleOutput(_ output: ImagesListViewModel.Output) {
        cancellables.addElements(
            updateDataSource(with: output.imagesDataSource),
            updateLoadingIndicator(with: output.loadingIndicatorDataSource)
        )
    }
    
    private func updateDataSource(with signal: PassthroughSubject<[Image], Never>) -> AnyCancellable {
        signal
            .receive(on: DispatchQueue.main)
            .sink { [weak self] images in
                guard let self else { return }
                imagesDataSource.append(contentsOf: images)
                updateData()
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
