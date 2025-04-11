//
//  BookmarkScreen.swift
//  MedBook
//
//  Created by Sai Prithvi on 16/03/25.
//

import SwiftUI

struct BookmarkScreen: View {
    @EnvironmentObject var router: RouterViewModel
    @StateObject private var viewModel = BookmarkViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            header
            
            if viewModel.bookmarks.isEmpty {
                emptyStateView
            } else {
                bookmarksList
            }
            
            Spacer()
        }
        .background(Color.primaryBgColor)
        .navigationBarHidden(true)
        .onAppear {
            viewModel.fetchBookmarks()
        }
    }
    
    private var header: some View {
        HStack {
            // Logo
            HStack(spacing: 4) {
                Image(systemName: "bookmark.fill")
                    .font(.title)
                Text("Bookmarks")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            Spacer()
            
            // Back button
            Button(action: {
                router.goBack()
            }) {
                Image(systemName: "xmark")
                    .font(.title3)
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "bookmark.slash")
                .font(.system(size: 64))
                .foregroundColor(.gray)
            Text("No bookmarks yet")
                .font(.title3)
                .fontWeight(.medium)
            Text("Books you bookmark will appear here")
                .font(.subheadline)
                .foregroundColor(.gray)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
    
    private var bookmarksList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.bookmarks, id: \.id) { bookmark in
                    BookCard(book: bookmark.toBook())
                        .padding(.horizontal)
                        .onTapGesture {
                            router.navigate(to: .bookDetail(book: bookmark.toBook()))
                        }
                }
            }
            .padding(.vertical)
        }
    }
}

extension BookmarkEntity {
    func toBook() -> Book {
        Book(
            title: self.title ?? "",
            key: self.id ?? "",
            ratingsAverage: self.rating,
            ratingsCount: Int(self.hits),
            authorName: self.author.map { [$0] },
            coverI: Int(self.coverId),
            firstPublishYear: Int(self.yearPublished),
            description: self.desc ?? ""
        )
    }
} 
