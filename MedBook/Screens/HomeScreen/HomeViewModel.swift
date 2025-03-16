//
//  HomeViewModel.swift
//  MedBook
//
//  Created by Sai Prithvi on 16/03/25.
//

import SwiftUI
import Combine

final class HomeViewModel: ObservableObject {
    let networkService: HomeNetworkServiceProtocol
    let nextNavigationStep = PassthroughSubject<AppRoute, Never>()
    
    @Published var searchText: String = "GAME"
    
    init(homeNetworkService: HomeNetworkServiceProtocol = HomeNetworkService()) {
        self.networkService = homeNetworkService
    }

    func onViewAppear() {
        searchBooks() // todo: remove this
    }
    
    func logout() {
        AuthHelper.shared.logout()
        nextNavigationStep.send(.landing)
    }
    
    func searchBooks() {
        networkService.fetchBooks(query: searchText, limit: 10, offset: 0) { [weak self] result in
            switch result {
                case .success(let response):
                    print(response)
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")   
            }
        }
    }
} 
