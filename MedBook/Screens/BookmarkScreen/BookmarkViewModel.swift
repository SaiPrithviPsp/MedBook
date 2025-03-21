//
//  BookmarkViewModel.swift
//  MedBook
//
//  Created by Sai Prithvi on 16/03/25.
//

import SwiftUI
import Combine

final class BookmarkViewModel: ObservableObject {
    @Published var bookmarks: [BookmarkEntity] = []
    private let bookmarkManager = BookmarkManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        // Subscribe to BookmarkManager changes
        bookmarkManager.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] (_: Void) in
                self?.fetchBookmarks()
            }
            .store(in: &cancellables)
    }
    
    func fetchBookmarks() {
        bookmarks = bookmarkManager.fetchBookmarks()
    }
} 
