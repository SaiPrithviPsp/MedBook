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
    @Published var sortOption: SortOption = .title {
        didSet {
            sortBooks()
        }
    }
    
    private var unsortedBooks: [Book] = []
    private var currentOffset: Int = 0
    private let booksPerPage: Int = 10
    
    private var cancellables = Set<AnyCancellable>()
    
    init(homeNetworkService: HomeNetworkServiceProtocol = HomeNetworkService()) {
        self.networkService = homeNetworkService
        setupSearchDebounce()
    }
    
    func logout() {
        AuthHelper.shared.logout()
        nextNavigationStep.send(.landing)
    }
    
    private func setupSearchDebounce() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main) // Delay API call
            .removeDuplicates() // Prevent duplicate calls
            .sink { [weak self] text in
                guard !text.isEmpty else { return }
                self?.searchBooks(for: text)
            }
            .store(in: &cancellables)
    }
    
    private func resetAndSearch() {
        books = []
        unsortedBooks = []
        currentOffset = 0
        hasMoreBooks = true
        searchBooks(for: searchText)
    }
    
    private func sortBooks() {
        switch sortOption {
        case .title:
            books = unsortedBooks.sorted { ($0.title).lowercased() < ($1.title).lowercased() }
        case .year:
            books = unsortedBooks.sorted { 
                guard let year1 = $0.firstPublishYear, let year2 = $1.firstPublishYear else { return false }
                return year1 > year2
            }
        case .hits:
            books = unsortedBooks.sorted {
                guard let count1 = $0.ratingsCount, let count2 = $1.ratingsCount else { return false }
                return count1 > count2
            }
        }
    }
    
    func loadMoreBooksIfNeeded(currentItem index: Int) {
        let thresholdIndex = books.count - 5
        if index == thresholdIndex && !isLoading && hasMoreBooks {
            searchBooks(for: searchText)
        }
    }
    
    func searchBooks(for text: String) {
        guard !isLoading && hasMoreBooks else { return }
        
        isLoading = true
        networkService.fetchBooks(query: text, limit: booksPerPage, offset: currentOffset) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                    case .success(let response):
                        let newBooks = response.docs
                        self.unsortedBooks.append(contentsOf: newBooks)
                        self.currentOffset += newBooks.count
                        self.hasMoreBooks = newBooks.count == self.booksPerPage
                        self.sortBooks()
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                        if self.currentOffset == 0 {
                            self.books = []
                            self.unsortedBooks = []
                        }
                }
            }
        }
    }
} 

enum SortOption: String {
    case title = "Title"
    case year = "Year"
    case hits = "Hits"
}
