//
//  Photo.swift
//  Unsplasher
//
//  Created by Вадим Шишков on 11.06.2024.
//

import Foundation

struct Photo: Decodable {
    let id: String
    let createdAt: String
    let likedByUser: Bool
    let downloads: Int
    let location: Location
    let urls: Urls
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case id, downloads, location, urls, user
        case createdAt = "created_at"
        case likedByUser = "liked_by_user"
    }
}
