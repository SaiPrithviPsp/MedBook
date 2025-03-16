//
//  HomeView.swift
//  MedBook
//
//  Created by Sai Prithvi on 16/03/25.
//

import SwiftUI

struct HomeScreen: View {
    @EnvironmentObject var router: RouterViewModel
    @StateObject private var viewModel = HomeViewModel()
    
    enum SortOption {
        case title, year, hits
    }
    
    @State private var selectedSort: SortOption = .title
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Header
            HStack {
                // Logo
                HStack(spacing: 4) {
                    Image(systemName: "books.vertical.fill")
                        .font(.title)
                    Text("MedBook")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                // Right buttons
                HStack(spacing: 16) {
                    Button(action: {
                        // TODO: Implement bookmark action
                    }) {
                        Image(systemName: "bookmark")
                            .font(.title3)
                            .foregroundColor(.black)
                    }
                    
                    Button(action: {
                        viewModel.logout()
                    }) {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .foregroundColor(.red)
                    }
                }
            }
            .padding(.horizontal)
            
            // Title and Search
            VStack(alignment: .leading, spacing: 16) {
                Text("Which topic interests\nyou today?")
                    .font(.title)
                    .fontWeight(.bold)
                
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search for books", text: $viewModel.searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                    if !viewModel.searchText.isEmpty {
                        Button(action: {
                            viewModel.searchText = ""
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
            .padding(.horizontal)
            
            // Sort Options
            if !viewModel.books.isEmpty {
                HStack(spacing: 16) {
                    Text("Sort By:")
                        .foregroundColor(.gray)
                    
                    ForEach([SortOption.title, .average, .hits], id: \.self) { option in
                        Button(action: {
                            selectedSort = option
                        }) {
                            Text(option == .title ? "Title" : option == .average ? "Average" : "Hits")
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(selectedSort == option ? Color.gray.opacity(0.2) : Color.clear)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            // Books List
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.books.indices, id: \.self) { index in
                        let book = viewModel.books[index]
                        BookCard(book: book)
                            .padding(.horizontal)
                            .onAppear {
                                viewModel.loadMoreBooksIfNeeded(currentItem: index)
                            }
                    }
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                }
                .padding(.vertical)
            }
            
            Spacer()
        }
        .navigationBarHidden(true)
        .onReceive(viewModel.nextNavigationStep) { newValue in
            router.navigate(to: newValue)
        }
        .onAppear {
            viewModel.onViewAppear()
        }
    }
}

struct BookCard: View {
    let book: Book
    
    var body: some View {
        HStack(spacing: 16) {
            bookImage
            
            // Book Details
            VStack(alignment: .leading, spacing: 4) {
                Text(book.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(book.authorName?.first ?? "")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
               HStack {
                   // Rating
                   if let ratingsAverage = book.ratingsAverage {
                       Image(systemName: "star.fill")
                           .foregroundColor(.yellow)
                       Text(String(format: "%.1f", ratingsAverage))
                   }
                   
                   Spacer()
                   
                   if let ratingsCount = book.ratingsCount {
                       Image(systemName: "eye.fill")
                           .foregroundColor(.orange)
                       Text("\(ratingsCount)")
                   }
                   
                   if let yearPublished = book.firstPublishYear {
                       Text(String(yearPublished))
                   }
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
    private var bookImage: some View {
        if let imageId = book.coverI {
            AsyncImage(url: URL(string: getUrl(for: imageId))) { image in
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

    private func getUrl(for bookId: Int) -> String {
        let url = "https://covers.openlibrary.org/b/id/\(bookId)-M.jpg"
        print(url)
        return url
    }
}
