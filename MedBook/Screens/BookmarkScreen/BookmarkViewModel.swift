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
} 
