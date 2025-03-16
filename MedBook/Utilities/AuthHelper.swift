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
    
    @Published var isLoggedIn: Bool? = nil // `nil` means checking auth

    private init() {}

    func checkAuthenticationStatus() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // Simulated delay
            self.isLoggedIn = UserDefaults.standard.bool(forKey: self.authKey)
        }
    }

    func login() {
        UserDefaults.standard.setValue(true, forKey: authKey)
        isLoggedIn = true
    }

    func logout() {
        UserDefaults.standard.setValue(false, forKey: authKey)
        isLoggedIn = false
    }
}


