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
    
    @Published var searchText: String = "" {
        didSet {
            if searchText.count >= 3 {
                searchBooks()
            }
        }
    }
    
    @Published var books: [Book] = []
    @Published var isLoading: Bool = false
    
    init(homeNetworkService: HomeNetworkServiceProtocol = HomeNetworkService()) {
        self.networkService = homeNetworkService
    }

    func onViewAppear() {
        // Removed initial search call
    }
    
    func logout() {
        AuthHelper.shared.logout()
        nextNavigationStep.send(.landing)
    }
    
    func searchBooks() {
        isLoading = true
        networkService.fetchBooks(query: searchText, limit: 10, offset: 0) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                    case .success(let response):
                        self?.books = response.docs
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                        self?.books = []
                }
            }
        }
    }
} 
