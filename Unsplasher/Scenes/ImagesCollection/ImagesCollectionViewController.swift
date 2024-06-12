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
    private let service = PhotosService()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.contentInset = UIEdgeInsets(top: 0, left: Layout.inset, bottom: 0, right: Layout.inset)
        collectionView.backgroundColor = .mainBackground
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
        searchController.searchBar.placeholder = "Поиск"
        searchController.hidesNavigationBarDuringPresentation = false
        
        navigationItem.searchController = searchController
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            ImagesCollectionCell.self,
            forCellWithReuseIdentifier: ImagesCollectionCell.identifier
        )
    }
    
    private func fetchPhotos() {
        service.fetchPhotos { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let photos):
                    self?.photos = photos
                    self?.collectionView.reloadData()
                case .failure(let failure):
                    fatalError()
                }
            }
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
        let detailVC = DetailViewController()
        navigationController?.pushViewController(detailVC, animated: true)
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
