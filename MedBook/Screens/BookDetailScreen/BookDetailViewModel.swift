//
//  BookDetailViewModel.swift
//  MedBook
//
//  Created by Sai Prithvi on 02/04/25.
//

import SwiftUI
import Combine

final class BookDetailViewModel: ObservableObject {
    @Published var bookmarks: [Book] = []
    private let bookmarkManager = BookmarkManager.shared
    private var cancellables = Set<AnyCancellable>()
    private let networkService: HomeNetworkServiceProtocol
    
    init(key: String, homeNetworkService: HomeNetworkServiceProtocol = HomeNetworkService()) {
        self.networkService = homeNetworkService
        // if not in cache then fetch from API
        fetchBookDetails(for: key)
    }
    
    func fetchBookDetails(for key: String) {
        networkService.fetchBookDetails(key: key) { [weak self] result in
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
