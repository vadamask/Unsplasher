//
//  FavoriteImagesCell.swift
//  Unsplasher
//
//  Created by Вадим Шишков on 10.06.2024.
//
import Kingfisher
import UIKit

final class FavouriteImagesCell: UITableViewCell {
    static let identifier = "cell"
    var id: String?
    
    private let image: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .darkBlue
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        id = nil
        image.kf.cancelDownloadTask()
        label.text = ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: Photos) {
        self.id = model.id
        
        if let url = URL(string: model.urls.small) {
            image.kf.indicatorType = .activity
            image.kf.setImage(with: url)
        }
        
        label.text = model.user.name
    }
    
    private func setupConstraints() {
        contentView.addSubview(image)
        contentView.addSubview(label)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            image.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            image.widthAnchor.constraint(equalToConstant: 44),
            image.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 10)
        ])
    }
}
