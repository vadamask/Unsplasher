//
//  ImagesCollectionViewController.swift
//  Unsplasher
//
//  Created by Вадим Шишков on 10.06.2024.
//

import UIKit

final class ImagesCollectionViewController: UIViewController {
    
    private enum Layout {
        static let textFieldHeight: CGFloat = 35
        static let betweenCells: CGFloat = 5
        static let cellPerRow: CGFloat = 3
        static let inset: CGFloat = 16
    }
    
    private var photos: [Photos] = []
    private let service: PhotosServiceProtocol = PhotosService()
    
    private let refresher: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.tintColor = .gray
        refresher.addTarget(nil, action: #selector(pullToRefresh), for: .valueChanged)
        return refresher
    }()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.contentInset = UIEdgeInsets(top: 0, left: Layout.inset, bottom: 0, right: Layout.inset)
        collectionView.backgroundColor = .mainBackground
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setupViews()
        fetchPhotos()
    }
    
    private func setupViews() {
        view.backgroundColor = .mainBackground
        navigationItem.title = "Коллекция"
        
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        searchController.showsSearchResultsController = true
        searchController.searchBar.placeholder = "Поиск"
        searchController.hidesNavigationBarDuringPresentation = false
        
        navigationItem.searchController = searchController
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            ImagesCollectionCell.self,
            forCellWithReuseIdentifier: ImagesCollectionCell.identifier
        )
        collectionView.addSubview(refresher)
    }
    
    private func fetchPhotos() {
        service.fetchPhotos { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let photos):
                self.photos = photos
                self.collectionView.reloadData()
            case .failure(let error):
                AlertPresenter.show(in: self, model: AlertModel(message: error.localizedDescription))
            }
        }
    }
    
    @objc private func pullToRefresh() {
        collectionView.refreshControl?.beginRefreshing()
        
        service.fetchPhotos { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let photos):
                self.photos = photos
                self.collectionView.reloadData()
            case .failure(let error):
                AlertPresenter.show(in: self, model: AlertModel(message: error.localizedDescription))
            }
            #warning("Не останавливается")
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
}

// MARK: - Layout

extension ImagesCollectionViewController {
    private func setupConstraints() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - CollectionViewDataSource

extension ImagesCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        photos.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        guard let cell = collectionView
            .dequeueReusableCell(
                withReuseIdentifier: ImagesCollectionCell.identifier,
                for: indexPath
            ) as? ImagesCollectionCell else { return ImagesCollectionCell() }
        
        cell.configure(photos[indexPath.row])
        return cell
    }
}

// MARK: - CollectionViewLayout & Delegate

extension ImagesCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ImagesCollectionCell,
           let id = cell.id {
            let detailVC = DetailViewController(id: id)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        let screenWidth = view.bounds.width
        let emptySpace = (Layout.inset * 2) + (Layout.betweenCells * 2)
        let width = (screenWidth - emptySpace) / Layout.cellPerRow
        return CGSize(width: width, height: width)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        Layout.betweenCells
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        Layout.betweenCells
    }
}

// MARK: - Search

extension ImagesCollectionViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        
        service.searchPhotos(query: text) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let searchPhotos):
                self.photos = searchPhotos.results
                self.collectionView.reloadData()
            case .failure(let error):
                AlertPresenter.show(in: self, model: AlertModel(message: error.localizedDescription))
            }
            
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        if !text.isEmpty {
            fetchPhotos()
        }
    }
}
