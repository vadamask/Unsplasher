//
//  DetailViewController.swift
//  Unsplasher
//
//  Created by Вадим Шишков on 10.06.2024.
//

import Kingfisher
import UIKit

final class DetailViewController: UIViewController {
    
    private enum Layout {
        static let margin: CGFloat = 16
        static let symbolSize = CGSize(width: 30, height: 30)
        static let betweenLabels: CGFloat = 5
    }
    
    private let service: PhotosServiceProtocol = PhotosService()
    private var id = ""
    private var photo: Photo?
    
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
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .red
        button.isUserInteractionEnabled = true
        button.addTarget(nil, action: #selector(likeButtonTapped), for: .touchUpInside)
        return button
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
            guard let self else { return }
            
            switch result {
            case .success(let photo):
                self.photo = photo
                self.setInfo(photo)
            case .failure(let error):
                AlertPresenter.show(in: self, model: AlertModel(message: error.localizedDescription))
            }
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .mainBackground
    }
    
    private func setInfo(_ photo: Photo) {
        guard let url = URL(string: photo.urls.regular) else { return }
        
        self.imageView.kf.indicatorType = .activity
        self.imageView.kf.setImage(with: url) { [weak self] _ in
            self?.updateButton()
        }
        
        self.authorName.text = "Автор: \(photo.user.name)"
        self.date.text = "Дата создания: \(formattedDate(photo.createdAt))"
        self.downloads.text = "Количество скачиваний: \(photo.downloads ?? 0)"
        self.location.text = "Местоположение: \(photo.location.city ?? "-")"
    }
    
    @objc private func likeButtonTapped() {
        if let photo {
            if photo.likedByUser {
                service.dislike(id) { [weak self] result in
                    guard let self else { return }
                    
                    switch result {
                    case .success(_):
                        self.photo = Photo(
                            createdAt: photo.createdAt,
                            likedByUser: !photo.likedByUser,
                            downloads: photo.downloads,
                            location: photo.location,
                            user: photo.user,
                            urls: photo.urls
                        )
                    case .failure(let error):
                        AlertPresenter.show(in: self, model: AlertModel(message: error.localizedDescription))
                    }
                    self.updateButton()
                }
            } else {
                service.like(id) { [weak self] result in
                    guard let self else { return }
                    
                    switch result {
                    case .success(_):
                        self.photo = Photo(
                            createdAt: photo.createdAt,
                            likedByUser: !photo.likedByUser,
                            downloads: photo.downloads,
                            location: photo.location,
                            user: photo.user,
                            urls: photo.urls
                        )
                    case .failure(let error):
                        AlertPresenter.show(in: self, model: AlertModel(message: error.localizedDescription))
                    }
                    self.updateButton()
                }
            }
        }
    }
    
    private func updateButton() {
        guard let photo else { return }
        
        self.likeButton.setImage(
            photo.likedByUser ?
            UIImage(systemName: "heart.fill") :
                UIImage(systemName: "heart"),
            for: .normal)
        
    }
    
    private func formattedDate(_ date: String) -> String {
        let formatter = ISO8601DateFormatter()
        let date = formatter.date(from: date)!
        formatter.formatOptions = [.withFullDate]
        return formatter.string(from: date)
    }
}

//MARK: - Layout

extension DetailViewController {
    private func setupConstraints() {
        view.addSubview(imageView)
        view.addSubview(authorName)
        view.addSubview(date)
        view.addSubview(location)
        view.addSubview(downloads)
        view.addSubview(likeButton)
        
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
