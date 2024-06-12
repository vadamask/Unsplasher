//
//  Photos.swift
//  Unsplasher
//
//  Created by Вадим Шишков on 12.06.2024.
//

import Foundation

struct Photos: Decodable {
    let id: String
    let urls: Urls
}

struct Urls: Decodable {
    let thumb: String
    let small: String
    let regular: String
}
