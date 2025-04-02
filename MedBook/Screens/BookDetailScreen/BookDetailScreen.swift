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
        if let urlString = book.getImageUrl() {
            HStack {
                Spacer()
                CachedAsyncImage(url: URL(string: urlString)) { image in
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
                .font(.title)
                .foregroundColor(.black)
            
            Spacer()
            
            if let firstPublishYear = book.firstPublishYear {
                Text(String(firstPublishYear))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.top, 40)
    }
    
    private var authorNameView: some View {
        Text(book.authorName?[0] ?? "")
            .font(.headline)
            .foregroundColor(.black)
            .frame(alignment: .leading)
    }
    
    @ViewBuilder
    private var descriptionView: some View {
        Group {
            if book.description == nil || book.description!.isEmpty {
                loaderView
            } else {
                Text(book.description ?? "")
                    .font(.body)
                    .foregroundColor(.gray)
                    .lineLimit(nil)
            }
        }
        .padding(.top, 16)
    }
    
    private var loaderView: some View {
        HStack {
            Spacer()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .padding()
            Spacer()
        }
    }
    
    // move to a common place?
    
}
