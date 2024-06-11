//
//  PhotosRequest.swift
//  Unsplasher
//
//  Created by Вадим Шишков on 11.06.2024.
//

import Foundation

struct PhotosRequest: NetworkRequest {
    var endpoint: Endpoint = .getPhotos(page: 1)
    var method: HttpMethod = .get
}
