//
//  PhotosService.swift
//  Unsplasher
//
//  Created by Вадим Шишков on 11.06.2024.
//

import Foundation

protocol PhotosServiceProtocol {
    func fetchPhotos(completion: @escaping (Result<[Photos], NetworkServiceError>) -> Void)
    func fetchPhotoById(id: String, completion: @escaping (Result<Photo, NetworkServiceError>) -> Void)
    func searchPhotos(query: String, completion: @escaping (Result<SearchPhotos, NetworkServiceError>) -> Void)
    func like(_ id: String, completion: @escaping (Result<Void, NetworkServiceError>) -> Void)
    func dislike(_ id: String, completion: @escaping (Result<Void, NetworkServiceError>) -> Void)
    func fetchLikedPhotos(username: String, completion: @escaping (Result<[Photos], NetworkServiceError>) -> Void)
}

final class PhotosService: PhotosServiceProtocol {
   
    private let service = NetworkService()
    private var page = 1
    private var searchPage = 1
    private var likePage = 1
    private var searchTask: URLSessionDataTask?
    
    func fetchPhotos(completion: @escaping (Result<[Photos], NetworkServiceError>) -> Void) {
        let request = PhotosRequest()
        
        service.send(request: request, type: [Photos].self) { [weak self] result in
            switch result {
            case .success(let photos):
                completion(.success(photos))
                self?.page += 1
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchPhotoById(id: String, completion: @escaping (Result<Photo, NetworkServiceError>) -> Void) {
        let request = PhotoRequest(endpoint: .getPhotoById(id))
        
        service.send(request: request, type: Photo.self) { result in
            switch result {
            case .success(let photo):
                completion(.success(photo))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func searchPhotos(query: String, completion: @escaping (Result<SearchPhotos, NetworkServiceError>) -> Void) {
        let request = SearchPhotosRequest(endpoint: .searchPhotos(query: query, page: page))
        
        if searchTask != nil {
            searchTask?.cancel()
        }
        
        searchTask = service.send(request: request, type: SearchPhotos.self) { [weak self] result in
            switch result {
            case .success(let photos):
                completion(.success(photos))
                self?.searchPage += 1
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func like(_ id: String, completion: @escaping (Result<Void, NetworkServiceError>) -> Void) {
        let request = LikePhotoRequest(endpoint: .likePhoto(id: id))
        
        service.send(request: request) { result in
            switch result {
            case .success(_):
                completion(.success(Void()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func dislike(_ id: String, completion: @escaping (Result<Void, NetworkServiceError>) -> Void) {
        let request = UnlikePhotoRequest(endpoint: .unlikePhoto(id: id))
        
        service.send(request: request) { result in
            switch result {
            case .success(_):
                completion(.success(Void()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchLikedPhotos(username: String, completion: @escaping (Result<[Photos], NetworkServiceError>) -> Void) {
        
        let request = LikedPhotosRequest(endpoint: .likedPhotos(username: username, page: self.likePage))
        
        self.service.send(request: request, type: [Photos].self) { [weak self] result in
            switch result {
            case .success(let photos):
                completion(.success(photos))
                self?.likePage += 1
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
