//
//  SearchPhotos.swift
//  Unsplasher
//
//  Created by Вадим Шишков on 12.06.2024.
//

import Foundation

struct SearchPhotos: Decodable {
    let total: Int
    let totalPages: Int
    let results: [Photos]
    
    enum CodingKeys: String, CodingKey {
        case total, results
        case totalPages = "total_pages"
    }
}
