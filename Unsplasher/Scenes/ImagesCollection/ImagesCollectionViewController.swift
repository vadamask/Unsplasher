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
    }
    
    private func setupViews() {
        view.backgroundColor = .mainBackground

        
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            ImagesCollectionCell.self,
            forCellWithReuseIdentifier: ImagesCollectionCell.identifier
        )
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
        100
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagesCollectionCell.identifier, for: indexPath)
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
        
        guard let screenSize = view.window?.windowScene?.screen.bounds else {
            return CGSize(width: 0, height: 0)
        }
        
        let emptySpace = (Layout.inset * 2) + (Layout.betweenCells * 2)
        let width = (screenSize.width - emptySpace) / Layout.cellPerRow
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
