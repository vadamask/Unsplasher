//
//  ViewController.swift
//  Unsplasher
//
//  Created by Вадим Шишков on 10.06.2024.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupControllers()
    }
    
    private func setupControllers() {
        let imagesCollectionVC = ImagesCollectionViewController()
        let favoriteImagesVC = FavoriteImagesViewController()
        
        let collectionItem = UITabBarItem(
            title: "Коллекция",
            image: UIImage(systemName: "photo.circle"),
            tag: 0
        )
        
        let favoriteItem = UITabBarItem(
            title: "Избранное",
            image: UIImage(systemName: "heart.circle.fill"),
            tag: 1
        )
        
        imagesCollectionVC.tabBarItem = collectionItem
        favoriteImagesVC.tabBarItem = favoriteItem
        
        viewControllers = [imagesCollectionVC, favoriteImagesVC]
    }

}

