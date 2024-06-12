//
//  AuthService.swift
//  Unsplasher
//
//  Created by Вадим Шишков on 11.06.2024.
//

import Foundation

protocol AuthServiceProtocol {
    var authRequest: URLRequest? { get }
    func code(from url: URL) -> String?
    func fetchToken(_ code: String, completion: @escaping (Result<Void, Error>) -> Void)
}

final class AuthService: AuthServiceProtocol {
    
    private let networkService: NetworkServiceProtocol = NetworkService()
    
    private let clientID = "H9nrOYWdg-Cv3HeXRveND1hwA5bxcYmeSVhske_TSWI"
    private let clientSecret = "uHXsyFLQnEtE3iPLDnbbd64s4fHEC-WopMTj3xsOebo"
    private let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    private let scope = "public+read_user+write_likes"
    private let baseURL = "https://unsplash.com/oauth/authorize"
    private let tokenURL = "https://unsplash.com/oauth/token"
    
    var authRequest: URLRequest? {
        
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: scope)
        ]
        
        if let url = components?.url {
            let request = URLRequest(url: url)
            return request
        } else {
            return nil
        }
    }
    
    func code(from url: URL) -> String? {
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
           let items = components.queryItems,
           let code = items.first(where: { $0.name == "code" }) {
            return code.value
           }
        else {
            return nil
        }
    }
    
    func fetchToken(_ code: String, completion: @escaping (Result<Void, Error>) -> Void) {
        var components = URLComponents(string: tokenURL)
        components?.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "client_secret", value: clientSecret),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        if let url = components?.url {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            networkService.fetchToken(request) { result in
                switch result {
                case .success(let token):
                    TokenStorage.shared.token = token.value
                    completion(.success(Void()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
    }
    
}
