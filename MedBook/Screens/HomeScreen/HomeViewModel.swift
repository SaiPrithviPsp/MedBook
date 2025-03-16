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
    private let bookmarkManager = BookmarkManager.shared
    
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
        unsortedBooks = []
        currentOffset = 0
        hasMoreBooks = true
        searchBooks()
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
    
    // MARK: - Bookmark Methods
    
    func isBookmarked(_ book: Book) -> Bool {
        bookmarkManager.isBookmarked(book)
    }
    
    func toggleBookmark(for book: Book) {
        if isBookmarked(book) {
            bookmarkManager.removeBookmark(book)
        } else {
            bookmarkManager.bookmarkBook(book)
        }
        objectWillChange.send()
    }
} 

enum SortOption: String {
    case title = "Title"
    case year = "Year"
    case hits = "Hits"
}
