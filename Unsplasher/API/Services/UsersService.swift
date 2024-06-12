//
//  UsersService.swift
//  Unsplasher
//
//  Created by Вадим Шишков on 11.06.2024.
//

import Foundation

protocol UsersServiceProtocol {
    var username: String? { get }
    func fetchMyProfile(completion: @escaping (Result<Void, NetworkServiceError>) -> Void)
}

final class UsersService: UsersServiceProtocol {
    private let service = NetworkService()
    private var _username: String?
    
    var username: String? {
        _username
    }
    
    func fetchMyProfile(completion: @escaping (Result<Void, NetworkServiceError>) -> Void) {
        if username == nil {
            let request = MyProfileRequest()
            
            service.send(request: request, type: MyProfile.self) { [weak self] result in
                switch result {
                case .success(let profile):
                    self?._username = profile.username
                    completion(.success(Void()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            completion(.success(Void()))
        }
    }
}
