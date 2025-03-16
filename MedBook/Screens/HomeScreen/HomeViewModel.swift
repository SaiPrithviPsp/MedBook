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
                resetAndSearch()
            }
        }
    }
    
    @Published var books: [Book] = []
    @Published var isLoading: Bool = false
    @Published var hasMoreBooks: Bool = true
    
    private var currentOffset: Int = 0
    private let booksPerPage: Int = 10
    
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
    
    private func resetAndSearch() {
        books = []
        currentOffset = 0
        hasMoreBooks = true
        searchBooks()
    }
    
    func loadMoreBooksIfNeeded(currentItem index: Int) {
        let thresholdIndex = books.count - 3
        if index == thresholdIndex {
            searchBooks()
        }
    }
    
    func searchBooks() {
        guard !isLoading && hasMoreBooks else { return }
        
        isLoading = true
        networkService.fetchBooks(query: searchText, limit: booksPerPage, offset: currentOffset) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                    case .success(let response):
                        let newBooks = response.docs
                        self.books.append(contentsOf: newBooks)
                        self.currentOffset += newBooks.count
                        self.hasMoreBooks = newBooks.count == self.booksPerPage
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                        if self.currentOffset == 0 {
                            self.books = []
                        }
                }
            }
        }
    }
} 
