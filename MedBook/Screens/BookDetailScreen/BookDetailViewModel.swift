//
//  BookDetailViewModel.swift
//  MedBook
//
//  Created by Sai Prithvi on 02/04/25.
//

import SwiftUI
import Combine

final class BookDetailViewModel: ObservableObject {
    @Published var book: Book
    private let bookmarkManager = BookmarkManager.shared
    private var cancellables = Set<AnyCancellable>()
    private let networkService: HomeNetworkServiceProtocol
    
    init(book: Book, homeNetworkService: HomeNetworkServiceProtocol = HomeNetworkService()) {
        self.networkService = homeNetworkService
        self.book = book
        
        fetchBookDetails(for: book.key)
    }
    
    func fetchBookDetails(for key: String) {
        if BookmarkManager.shared.isBookmarked(self.book) {
            if let updatedBook = BookmarkManager.shared.fetchBook(key: key) {
                self.book = updatedBook
            }
        }
        
        if self.book.description == nil || self.book.description!.isEmpty {
            let actualKey = removePrefix(for: key)
            networkService.fetchBookDetails(key: actualKey) { [weak self] result in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    switch result {
                        case .success(let response):
                            self.handleResponse(response)
                        case .failure(let error):
                            print("Error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    // removes the prefix and returns the actual key.
    // ex: input: /works/OL49488W output: OL49488W
    private func removePrefix(for key: String) -> String {
        let components = key.split(separator: "/")
        return String(components[components.count - 1])
    }
    
    private func handleResponse(_ response: GetBookDetailsResponse) {
        self.book.description = response.description
        if BookmarkManager.shared.isBookmarked(self.book) {
            BookmarkManager.shared.updateBook(self.book, description: response.description)
        }
    }
}
