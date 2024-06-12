//
//  MyProfileRequest.swift
//  Unsplasher
//
//  Created by Вадим Шишков on 12.06.2024.
//

import Foundation

struct MyProfileRequest: NetworkRequest {
    var endpoint: Endpoint = .me
    var method: HttpMethod = .get
}
