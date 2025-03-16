//
//  HomeViewModel.swift
//  MedBook
//
//  Created by Sai Prithvi on 16/03/25.
//

import SwiftUI
import Combine

final class HomeViewModel: ObservableObject {
    let networkService: UserNetworkServiceProtocol
    let nextNavigationStep = PassthroughSubject<AppRoute, Never>()
    
    @Published var searchText: String = ""
    
    init(userNetworkService: UserNetworkServiceProtocol = UserNetworkService()) {
        self.networkService = userNetworkService
    }
    
    func logout() {
        AuthHelper.shared.logout()
        nextNavigationStep.send(.landing)
    }
    
    func searchBooks() {
        // TODO: Implement book search functionality
        print("Searching for: \(searchText)")
    }
    
    func navigateToDetail(message: String) {
        // TODO: Implement when detail route is available
    }
    
    func navigateToSettings() {
        // TODO: Implement when settings route is available
    }
} 