//
//  SignUpViewModel.swift
//  MedBook
//
//  Created by Sai Prithvi on 16/03/25.
//

import Foundation

final class SignUpViewModel: ObservableObject {
    let networkService: UserNetworkServiceProtocol
    
    @Published var email: String = ""
    @Published var password: String = ""
    init(userNetworkService: UserNetworkServiceProtocol = UserNetworkService()) {
        self.networkService = userNetworkService
    }
    
    func onViewAppear() {
        fetchUser(userId: 1)
    }
    
    func didTapSignUpButton() {
        
    }
    
    func countryList() {
        
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
