//
//  PhotoRequest.swift
//  Unsplasher
//
//  Created by Вадим Шишков on 12.06.2024.
//

import Foundation

struct PhotoRequest: NetworkRequest {
    var endpoint: Endpoint
    var method: HttpMethod = .get
}
