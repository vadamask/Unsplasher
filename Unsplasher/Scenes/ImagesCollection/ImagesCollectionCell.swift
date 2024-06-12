//
//  ImagesCollectionCell.swift
//  Unsplasher
//
//  Created by Вадим Шишков on 10.06.2024.
//
import Kingfisher
import UIKit

final class ImagesCollectionCell: UICollectionViewCell {
    static let identifier = "Cell"
    private lazy var imageView = UIImageView(frame: contentView.bounds)
    var id: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .lightGray
        
        imageView.contentMode = .scaleAspectFill
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask()
        id = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ model: Photos) {
        id = model.id
        
        imageView.kf.indicatorType = .activity
        if let url = URL(string: model.urls.small) {
            imageView.kf.setImage(with: url)
        }
    }
}
