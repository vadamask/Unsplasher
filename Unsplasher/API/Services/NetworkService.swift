//
//  NetworkService.swift
//  Unsplasher
//
//  Created by Вадим Шишков on 11.06.2024.
//

import Foundation

enum NetworkServiceError: Error {
    case httpStatusCode(Int, Data)
    case urlRequestError(Error)
    case urlSessionError
    case parsingError
}

protocol NetworkServiceProtocol {
    func fetchToken(_ request: URLRequest, completion: @escaping (Result<Token, NetworkServiceError>) -> Void)
    
    func send<T: Decodable>(
        request: NetworkRequest,
        type: T.Type,
        completion: @escaping (Result<T, NetworkServiceError>) -> Void
    ) -> URLSessionDataTask?
}

final class NetworkService: NetworkServiceProtocol {
    func fetchToken(_ request: URLRequest, completion: @escaping (Result<Token, NetworkServiceError>) -> Void) {
        send(request: request) { result in
            switch result {
            case let .success(data):
                let result = self.parse(data: data, type: Token.self)
                completion(result)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    @discardableResult
    func send<T: Decodable>(
        request: NetworkRequest,
        type: T.Type,
        completion: @escaping (Result<T, NetworkServiceError>) -> Void
    ) -> URLSessionDataTask? {
        
        guard let urlRequest = createURLRequestFrom(request) else { return nil }
        
        return send(request: urlRequest) { result in
            switch result {
            case .success(let data):
                let result = self.parse(data: data, type: type)
                completion(result)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func send(
        request: NetworkRequest,
        completion: @escaping (Result<Void, NetworkServiceError>) -> Void
    ) {
        
        guard let urlRequest = createURLRequestFrom(request) else { return }
        
        send(request: urlRequest) { result in
            switch result {
            case .success(_):
                completion(.success(Void()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    @discardableResult
    private func send(
        request: URLRequest,
        completion: @escaping (Result<Data, NetworkServiceError>) -> Void
    ) -> URLSessionDataTask {
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error {
                    completion(.failure(.urlRequestError(error)))
                    return
                }
                
                guard let code = (response as? HTTPURLResponse)?.statusCode else { return }
                
                if let data = data {
                    if 200..<300 ~= code {
                        completion(.success(data))
                    } else {
                        completion(.failure(.httpStatusCode(code, data)))
                    }
                } else {
                    completion(.failure(.urlSessionError))
                }
            }
        }
        task.resume()
        return task
    }
    
    private func createURLRequestFrom(_ request: NetworkRequest) -> URLRequest? {
        let url = request.endpoint.url
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        if let token = request.token {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        return urlRequest
    }
    
    private func parse<T: Decodable>(data: Data, type: T.Type) -> Result<T, NetworkServiceError> {
        do {
            let response = try JSONDecoder().decode(type, from: data)
            return .success(response)
        } catch {
            return .failure(.parsingError)
        }
    }
}
