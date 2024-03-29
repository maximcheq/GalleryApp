//
//  FavoritesListViewController.swift
//  GalleryApp
//
//  Created by Maksim Kuklitski on 28.03.24.
//

import UIKit
import Combine

final class FavoritesListViewController: UIViewController {
    
    private let tableView = UITableView()
    
    private var favoritesDataSource: [Image] = []
    
    private let deleteFavoriteSignal = PassthroughSubject<Image, Never>()
    private let favoritesFetchSignal = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // swiftlint:disable implicitly_unwrapped_optional
    var viewModel: FavoritesListViewModel!
    // swiftlint:enable implicitly_unwrapped_optional

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureView()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoritesFetchSignal.send()
    }
    
    private func bindViewModel() {
        let input = FavoritesListViewModel.Input(
            favoritesFetchSignal: favoritesFetchSignal, 
            deleteFavoriteSignal: deleteFavoriteSignal
        )
        
        viewModel.transform(input, outputHandler: handleOutput)
    }
    
    private func handleOutput(_ output: FavoritesListViewModel.Output) {
        cancellables.addElements(
            updateTableView(with: output.favoritesDataSource)
        )
    }
    
    private func updateTableView(with signal: PassthroughSubject<[Image], Never>) -> AnyCancellable {
        signal
            .receive(on: DispatchQueue.main)
            .sink { [weak self] favorites in
                guard let self else { return }

                favoritesDataSource = favorites
                tableView.reloadData()
            }
    }
    
    private func configureView() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureTableView() {
        view.addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
    }
}

extension FavoritesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favoritesDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID, for: indexPath) as? FavoriteCell else {
            return UITableViewCell()
        }
        let favorite = favoritesDataSource[indexPath.row]
        cell.set(favorite: favorite)
        return cell
    }
}

extension FavoritesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let favorite = favoritesDataSource[indexPath.row]
        
        favoritesDataSource.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        
        deleteFavoriteSignal.send(favorite)
    }
}
