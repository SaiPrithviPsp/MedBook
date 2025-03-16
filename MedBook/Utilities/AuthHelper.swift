//
//  AuthHelper.swift
//  MedBook
//
//  Created by Sai Prithvi on 16/03/25.
//

import Foundation

enum LoginResult {
    case success
    case invalidCredentials
    case userNotFound
    case error(Error)
}

enum SignUpResult {
    case success
    case userAlreadyExists
    case error(Error)
}

class AuthHelper: ObservableObject {
    static let shared = AuthHelper() // Singleton instance
    
    private let isLoggedInKey = "isLoggedIn"

    private init() {}

    func isUserLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: self.isLoggedInKey)
    }
    
    func login(email: String, password: String) -> LoginResult {
        do {
            if let data = try? KeychainHelper.standard.read(service: "MedBook", account: email),
               let savedCredentials = try? JSONDecoder().decode(UserCredentials.self, from: data) {
                if savedCredentials.password == password {
                    print("Login successful")
                    UserDefaults.standard.setValue(true, forKey: isLoggedInKey)
                    return .success
                } else {
                    print("Invalid credentials")
                    return .invalidCredentials
                }
            } else {
                print("User not found")
                return .userNotFound
            }
        } catch {
            return .error(error)
        }
    }
    
    func signup(email: String, password: String) -> SignUpResult {
        // Check if user already exists
        if let _ = try? KeychainHelper.standard.read(service: "MedBook", account: email) {
            print("User already exists")
            return .userAlreadyExists
        }
        
        let credentials = UserCredentials(email: email, password: password)
        do {
            let data = try JSONEncoder().encode(credentials)
            try KeychainHelper.standard.save(data, service: "MedBook", account: email)
            UserDefaults.standard.setValue(true, forKey: isLoggedInKey)
            return .success
        } catch {
            print("Error saving to Keychain: \(error.localizedDescription)")
            return .error(error)
        }
    }

    func logout() {
        UserDefaults.standard.setValue(false, forKey: isLoggedInKey)
    }
}


