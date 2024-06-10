//
//  ImagesCollectionCell.swift
//  Unsplasher
//
//  Created by Вадим Шишков on 10.06.2024.
//

import UIKit

final class ImagesCollectionCell: UICollectionViewCell {
    static let identifier = "Cell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .gray
        layer.cornerRadius = 5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
