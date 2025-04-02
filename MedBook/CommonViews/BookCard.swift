//
//  BookCard.swift
//  MedBook
//
//  Created by Sai Prithvi on 17/03/25.
//

import SwiftUI

struct BookCard: View {
    let book: Book
    @ObservedObject var bookmarkManager = BookmarkManager.shared
    
    var body: some View {
        HStack(spacing: 16) {
            imageView
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    title
                    Spacer()
                    bookmarkButton
                }
                
                authorName
                
                HStack {
                    if let yearPublished = book.firstPublishYear {
                        Text(String(yearPublished))
                    }
                    
                    ratings
                    Spacer()
                    ratingCount
                }
                .font(.subheadline)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }

    @ViewBuilder
    private var imageView: some View {
        if let urlString = book.getImageUrl() {
            CachedAsyncImage(url: URL(string: urlString)) { image in
               image
                   .resizable()
                   .aspectRatio(contentMode: .fill)
           } placeholder: {
               Color.gray.opacity(0.2)
           }
           .frame(width: 80, height: 80)
           .cornerRadius(8)
        }
    }
    
    private var title: some View {
        Text(book.title)
            .font(.headline)
            .lineLimit(2)
    }
    
    private var authorName: some View {
        Text(book.authorName?.first ?? "")
            .font(.subheadline)
            .foregroundColor(.gray)
    }
    
    @ViewBuilder
    private var ratings: some View {
        if let ratingsAverage = book.ratingsAverage {
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
            Text(String(format: "%.1f", ratingsAverage))
        }
    }
    
    @ViewBuilder
    private var ratingCount: some View {
        if let ratingsCount = book.ratingsCount {
            Image(systemName: "eye.fill")
                .foregroundColor(.orange)
            Text("\(ratingsCount)")
        }
    }
    
    private var bookmarkButton: some View {
        Button(action: {
            bookmarkManager.toggleBookmark(for: book)
        }) {
            Image(systemName: bookmarkManager.isBookmarked(book) ? "bookmark.fill" : "bookmark")
                .foregroundColor(bookmarkManager.isBookmarked(book) ? .blue : .gray)
        }
    }

    private func getUrl(for bookId: Int) -> String {
        return "https://covers.openlibrary.org/b/id/\(bookId)-M.jpg"
    }
}
