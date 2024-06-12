//
//  DetailViewController.swift
//  Unsplasher
//
//  Created by Вадим Шишков on 10.06.2024.
//

import Kingfisher
import UIKit

final class DetailViewController: UIViewController {
    
    private var id = ""
    
    private enum Layout {
        static let margin: CGFloat = 16
        static let symbolSize = CGSize(width: 30, height: 30)
        static let betweenLabels: CGFloat = 5
    }
    
    private let service = PhotosService()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let authorName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .darkBlue
        return label
    }()
    
    private let date: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .darkBlue
        return label
    }()
    
    private let location: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .darkBlue
        return label
    }()
    
    private let downloads: UILabel = {
        let label = UILabel()
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
    
    init(id: String) {
        super.init(nibName: nil, bundle: nil)
        self.id = id
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
        service.fetchPhotoById(id: id) { [weak self] result in
            switch result {
            case .success(let photo):
                self?.setInfo(photo)
            case .failure(let error):
                fatalError()
            }
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .mainBackground
    }
    
    private func setInfo(_ photo: Photo) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            guard let url = URL(string: photo.urls.regular) else { return }
            
            self.imageView.kf.indicatorType = .activity
            self.imageView.kf.setImage(with: url)
            self.authorName.text = "Автор: \(photo.user.name)"
            self.date.text = "Дата создания: \(photo.createdAt)"
            self.downloads.text = "Количество скачианий: \(photo.downloads.description)"
            self.location.text = "Место положение: \(photo.location.city)"
        }
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
