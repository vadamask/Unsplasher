//
//  Token.swift
//  Unsplasher
//
//  Created by Вадим Шишков on 11.06.2024.
//

import Foundation

struct Token: Decodable {
    let value: String
    
    enum CodingKeys: String, CodingKey {
        case value = "access_token"
    }
}
