//
//  LoginViewModel.swift
//  MedBook
//
//  Created by Sai Prithvi on 16/03/25.
//

import SwiftUI
import Combine

final class LoginViewModel: ObservableObject {
    let networkService: UserNetworkServiceProtocol
    
    @Published var email: String = "" {
        didSet {
            validateEmail()
            updateCTAState()
        }
    }
    @Published var password: String = "" {
        didSet {
            validatePassword()
            updateCTAState()
        }
    }
    @Published var isPrimaryCtaEnabled: Bool = false
    @Published var emailError: String?
    @Published var passwordError: String?
    let nextNavigationStep = PassthroughSubject<AppRoute, Never>()
    
    init(userNetworkService: UserNetworkServiceProtocol = UserNetworkService()) {
        self.networkService = userNetworkService
    }
    
    private func validateEmail() {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        
        if email.isEmpty {
            emailError = "Email is required"
        } else if !emailPredicate.evaluate(with: email) {
            emailError = "Please enter a valid email"
        } else {
            emailError = nil
        }
    }
    
    private func validatePassword() {
        if password.isEmpty {
            passwordError = "Password is required"
        } else {
            passwordError = nil
        }
    }
    
    private func updateCTAState() {
        isPrimaryCtaEnabled = (emailError == nil && passwordError == nil && !email.isEmpty && !password.isEmpty)
    }
    
    func didTapLoginButton() {
        guard isPrimaryCtaEnabled else { return }
        
        // Here you would typically make a network call to authenticate the user
        // For now, we'll just verify against stored credentials
        do {
            if let data = try? KeychainHelper.standard.read(service: "MedBook", account: email),
               let savedCredentials = try? JSONDecoder().decode(UserCredentials.self, from: data) {
                if savedCredentials.password == password {
                    print("Login successful")
                    AuthHelper.shared.login()
                    nextNavigationStep.send(.home)
                    // Handle successful login (e.g., navigate to main screen)
                } else {
                    print("Invalid credentials")
                    // Handle invalid credentials
                }
            } else {
                print("User not found")
                // Handle user not found
            }
        }
    }
} 
