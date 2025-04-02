//
//  BookDetailScreen.swift
//  MedBook
//
//  Created by Sai Prithvi on 02/04/25.
//

import SwiftUI

struct BookDetailScreen: View {
    @EnvironmentObject var router: RouterViewModel
    @StateObject var viewModel: BookDetailViewModel
    @ObservedObject var bookmarkManager = BookmarkManager.shared
    
    private var book: Book {
        viewModel.book
    }
    var body: some View {
        VStack(alignment: .leading) {
            navbar
            contentView
            Spacer()
        }
        .background(Color.primaryBgColor)
        .navigationBarHidden(true)
    }
    
    private var navbar: some View {
        HStack {
            Button(action: {
                router.goBack()
            }) {
                Image(systemName: "xmark")
                    .font(.title3)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button(action: {
                bookmarkManager.toggleBookmark(for: book)
            }) {
                Image(systemName: bookmarkManager.isBookmarked(book) ? "bookmark.fill" : "bookmark")
                    .foregroundColor(bookmarkManager.isBookmarked(book) ? .blue : .gray)
            }
        }
        .padding(.horizontal)
        .padding(.top, 24)
    }
    
    private var contentView: some View {
        ScrollView {
            VStack(alignment: .leading) {
                imageView
                nameDateView
                authorNameView
                descriptionView
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    private var imageView: some View {
        if let imageId = book.coverI {
            HStack {
                Spacer()
                CachedAsyncImage(url: URL(string: getUrl(for: imageId))) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(width: 200, height: 300)
                .cornerRadius(8)
                Spacer()
            }
           .padding(.top, 24)
        }
    }
    
    private var nameDateView: some View {
        HStack {
            Text(book.title)
                .font(.headline)
                .foregroundColor(.black)
            
            Spacer()
            
            Text("\(book.firstPublishYear)")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.top, 40)
    }
    
    private var authorNameView: some View {
        Text(book.authorName?[0] ?? "")
            .font(.body)
            .foregroundColor(.black)
            .frame(alignment: .leading)
    }
    
    private var descriptionView: some View {
        Text(book.description ?? "")
            .font(.caption)
            .foregroundColor(.gray)
            .lineLimit(nil)
    }
    
    // move to a common place?
    private func getUrl(for bookId: Int) -> String {
        return "https://covers.openlibrary.org/b/id/\(bookId)-M.jpg"
    }
}
