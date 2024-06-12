//
//  Endpoint.swift
//  Unsplasher
//
//  Created by Вадим Шишков on 11.06.2024.
//

import Foundation

enum Endpoint {
    case getPhotos(page: Int, perPage: Int)
    case getPhotoById(String)
    case searchPhotos(query: String, page: Int)
    case likePhoto(id: String)
    case unlikePhoto(id: String)
    case me
    
    var url: URL {
        guard let url = URL(string: endpoint, relativeTo: baseURL) else {
            fatalError("Something wrong with url")
        }
        return url
    }
    
    private var endpoint: String {
        switch self {
        case .getPhotos(let page, let perPage): "/photos?page=\(page)&per_page=\(perPage)"
        case .getPhotoById(let id): "/photos/\(id)"
        case .searchPhotos(let query, let page): "/search/photos?page=\(page)&query=\(query)"
        case .likePhoto(let id): "/photos/\(id)/like"
        case .unlikePhoto(let id): "/photos/\(id)/like"
        case .me: "/me"
        }
    }
    
    private var baseURL: URL? {
        URL(string: "https://api.unsplash.com")
    }
}
