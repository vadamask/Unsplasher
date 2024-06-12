//
//  Photo.swift
//  Unsplasher
//
//  Created by Вадим Шишков on 11.06.2024.
//

import Foundation

struct Photo: Decodable {
    
    let createdAt: String
    let likedByUser: Bool
    let downloads: Int
    let location: Location
    let user: User
    let urls: Urls
    
    enum CodingKeys: String, CodingKey {
        case downloads, location, user, urls
        case createdAt = "created_at"
        case likedByUser = "liked_by_user"
    }
}

struct Location: Decodable {
    let city: String
    let country: String
}

struct User: Decodable {
    let name: String
}
