//
//  NetworkRequest.swift
//  Unsplasher
//
//  Created by Вадим Шишков on 11.06.2024.
//

import Foundation

protocol NetworkRequest {
    var endpoint: Endpoint { get }
    var method: HttpMethod { get }
    var token: String? { get }
}

extension NetworkRequest {
    var token: String? {
        "123"
    }
}
