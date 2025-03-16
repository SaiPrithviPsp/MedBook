//
//  SignUpViewModel.swift
//  MedBook
//
//  Created by Sai Prithvi on 16/03/25.
//

import SwiftUI

struct Country {
    
}

final class SignUpViewModel: ObservableObject {
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
    @Published var countryList: [String] = []
    @Published var selectedCountry: String = ""
    @Published var isPrimaryCtaEnabled: Bool = false
    @Published var emailError: String?
    @Published var passwordError: String?
    
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
            return
        }
        
        let hasMinLength = password.count >= 8
        let hasNumber = password.contains(where: { $0.isNumber })
        let hasUppercase = password.contains(where: { $0.isUppercase })
        let specialCharacters = CharacterSet(charactersIn: "!@#$%^&*()_+-=[]{}|;:,.<>?")
        let hasSpecialCharacter = password.rangeOfCharacter(from: specialCharacters) != nil
        
        if !hasMinLength {
            passwordError = "Password must be at least 8 characters"
        } else if !hasNumber {
            passwordError = "Password must contain at least 1 number"
        } else if !hasUppercase {
            passwordError = "Password must contain at least 1 uppercase character"
        } else if !hasSpecialCharacter {
            passwordError = "Password must contain at least 1 special character"
        } else {
            passwordError = nil
        }
    }
    
    private func updateCTAState() {
        isPrimaryCtaEnabled = (emailError == nil && passwordError == nil && !selectedCountry.isEmpty)
    }
    
    func onViewAppear() {
        getCountryList()
    }
    
    func didTapSignUpButton() {
        
    }
    
    func getCountryList() {
        networkService.fetchCountries { result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let response):
                        self.countryList = Array(response.data.values).map { $0.country }
                        if !self.countryList.isEmpty {
                            self.selectedCountry = self.countryList[0]
                            self.updateCTAState()
                        }
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetchUser(userId: Int) {
        networkService.fetchUser(userId: userId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let user):
                        print(user)
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
}
