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
        
        // if not in cache then fetch from API
        if book.description == nil || book.description!.isEmpty {
            fetchBookDetails(for: book.key)
        }
    }
    
    // removes the prefix and returns the actual key.
    // ex: input: /works/OL49488W output: OL49488W
    private func removePrefix(for key: String) -> String {
        let components = key.split(separator: "/")
        return String(components[components.count - 1])
    }
    
    func fetchBookDetails(for key: String) {
        let actualKey = removePrefix(for: key)
        networkService.fetchBookDetails(key: actualKey) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                    case .success(let response):
                        print(response)
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
}
