//
//  FavoriteImagesViewController.swift
//  Unsplasher
//
//  Created by Вадим Шишков on 10.06.2024.
//

import UIKit

final class FavouriteImagesViewController: UIViewController {
    
    private var photos: [Photos] = []
    private let photosService: PhotosServiceProtocol = PhotosService()
    private let usersService: UsersServiceProtocol = UsersService()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .mainBackground
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
        usersService.fetchMyProfile { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(_):
                self.fetchLikedPhotos()
            case .failure(let error):
                AlertPresenter.show(in: self, model: AlertModel(message: error.localizedDescription))
            }
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .mainBackground
        title = "Избранное"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavouriteImagesCell.self, forCellReuseIdentifier: FavouriteImagesCell.identifier)
    }
    
    private func fetchLikedPhotos() {
        if let username = usersService.username {
            photosService.fetchLikedPhotos(username: username) { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .success(let photos):
                    self.photos = photos
                    self.tableView.reloadData()
                case .failure(let error):
                    AlertPresenter.show(in: self, model: AlertModel(message: error.localizedDescription))
                }
            }
        }
        
    }
}

// MARK: - Layout

extension FavouriteImagesViewController {
    private func setupConstraints() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - TableViewDataSource

extension FavouriteImagesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(
                withIdentifier: FavouriteImagesCell.identifier,
                for: indexPath
            ) as? FavouriteImagesCell else { return FavouriteImagesCell() }
        cell.configure(with: photos[indexPath.row])
        return cell
    }
}

// MARK: - TableViewDelegate

extension FavouriteImagesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath) as? FavouriteImagesCell,
           let id = cell.id {
            let detailVC = DetailViewController(id: id)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    
}
