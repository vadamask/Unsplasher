//
//  DetailViewController.swift
//  Unsplasher
//
//  Created by Вадим Шишков on 10.06.2024.
//

import UIKit

final class DetailViewController: UIViewController {
    
    private enum Layout {
        static let margin: CGFloat = 16
        static let symbolSize = CGSize(width: 30, height: 30)
        static let betweenLabels: CGFloat = 5
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.image = UIImage(resource: .test)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private let authorName: UILabel = {
        let label = UILabel()
        label.text = "Автор: Vadim Shishkov"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .darkBlue
        return label
    }()
    
    private let date: UILabel = {
        let label = UILabel()
        label.text = "Дата создания: 10.06.2024"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .darkBlue
        return label
    }()
    
    private let location: UILabel = {
        let label = UILabel()
        label.text = "Местоположение: Москва"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .darkBlue
        return label
    }()
    
    private let downloads: UILabel = {
        let label = UILabel()
        label.text = "Количество скачиваний: 1000"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .darkBlue
        return label
    }()
    
    private let likeButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart")
        imageView.tintColor = .red
        
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = .mainBackground
    }
}

//MARK: - Layout

extension DetailViewController {
    private func setupConstraints() {
        view.addSubview(imageView)
        imageView.addSubview(likeButton)
        
        view.addSubview(authorName)
        view.addSubview(date)
        view.addSubview(location)
        view.addSubview(downloads)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        authorName.translatesAutoresizingMaskIntoConstraints = false
        date.translatesAutoresizingMaskIntoConstraints = false
        location.translatesAutoresizingMaskIntoConstraints = false
        downloads.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: view.bounds.width - Layout.margin * 2)
        ])
        
        NSLayoutConstraint.activate([
            authorName.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            authorName.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            authorName.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            date.topAnchor.constraint(equalTo: authorName.bottomAnchor, constant: Layout.betweenLabels),
            date.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            date.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            location.topAnchor.constraint(equalTo: date.bottomAnchor, constant: Layout.betweenLabels),
            location.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            location.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            downloads.topAnchor.constraint(equalTo: location.bottomAnchor, constant: Layout.betweenLabels),
            downloads.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            downloads.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: imageView.layoutMarginsGuide.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: imageView.layoutMarginsGuide.trailingAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: Layout.symbolSize.width),
            likeButton.heightAnchor.constraint(equalToConstant: Layout.symbolSize.height),
        ])
    }
}
