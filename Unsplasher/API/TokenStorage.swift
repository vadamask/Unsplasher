//
//  TokenStorage.swift
//  Unsplasher
//
//  Created by Вадим Шишков on 11.06.2024.
//

import Foundation
import SwiftKeychainWrapper

final class TokenStorage {
    static let shared = TokenStorage()
    private let key = "token"
    
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: key)
        }
        set {
            if let newValue {
                KeychainWrapper.standard.set(newValue, forKey: key)
            } else {
                KeychainWrapper.standard.removeObject(forKey: key)
            }
        }
    }
    private init(){}
}
