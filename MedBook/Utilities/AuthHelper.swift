//
//  AuthHelper.swift
//  MedBook
//
//  Created by Sai Prithvi on 16/03/25.
//

import Foundation

class AuthHelper: ObservableObject {
    static let shared = AuthHelper() // Singleton instance
    
    private let authKey = "isLoggedIn"

    private init() {}

    func isUserLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: self.authKey)
    }
    
    func login() {
        UserDefaults.standard.setValue(true, forKey: authKey)
    }

    func logout() {
        UserDefaults.standard.setValue(false, forKey: authKey)
    }
}


