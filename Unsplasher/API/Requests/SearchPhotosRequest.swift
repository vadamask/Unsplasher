//
//  SearchPhotosRequest.swift
//  Unsplasher
//
//  Created by Вадим Шишков on 11.06.2024.
//

import Foundation

struct SearchPhotosRequest: NetworkRequest {
    var endpoint: Endpoint
    var method: HttpMethod = .get
}
