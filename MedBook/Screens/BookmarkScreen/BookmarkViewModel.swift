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
    
    func fetchBookmarks() {
        bookmarks = bookmarkManager.fetchBookmarks()
    }
    
    func isBookmarked(_ book: Book) -> Bool {
        bookmarkManager.isBookmarked(book)
    }
    
    func toggleBookmark(for book: Book) {
        if isBookmarked(book) {
            bookmarkManager.removeBookmark(book)
        } else {
            bookmarkManager.bookmarkBook(book)
        }
        fetchBookmarks()
    }
} 
