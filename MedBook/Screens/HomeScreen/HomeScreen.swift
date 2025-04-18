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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            header
            
            VStack(alignment: .leading, spacing: 16) {
                title
                searchBar
            }
            .padding(.horizontal)
            sortOptions
            booksList
            
            Spacer()
        }
        .navigationBarHidden(true)
        .background(Color.primaryBgColor)
        .onReceive(viewModel.nextNavigationStep) { newValue in
            router.navigate(to: newValue)
        }
    }
    
    private var header: some View {
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
            
            HStack(spacing: 16) {
                Button(action: {
                    router.navigate(to: .bookmarks)
                }) {
                    Image(systemName: "bookmark.fill")
                        .font(.title3)
                        .foregroundColor(.black)
                }
                
                Button(action: {
                    viewModel.logout()
                }) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.title3)
                        .foregroundColor(.red)
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var title: some View {
        Text("Which topic interests\nyou today?")
            .font(.title)
            .fontWeight(.bold)
    }
    
    private var searchBar: some View {
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
    
    @ViewBuilder
    private var sortOptions: some View {
        if !viewModel.books.isEmpty {
            HStack(spacing: 16) {
                Text("Sort By:")
                    .foregroundColor(.black)
                
                ForEach([SortOption.title, .year, .hits], id: \.self) { option in
                    Button(action: {
                        viewModel.sortOption = option
                    }) {
                        Text(option.rawValue)
                            .foregroundStyle(Color.black)
                            .fontWeight(.bold)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(viewModel.sortOption == option ? Color.gray.opacity(0.2) : Color.clear)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var booksList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.books.indices, id: \.self) { index in
                    let book = viewModel.books[index]
                    BookCard(book: book)
                        .padding(.horizontal)
                        .onAppear {
                            viewModel.loadMoreBooksIfNeeded(currentItem: index)
                        }
                        .id(book.key)
                        .onTapGesture {
                            router.navigate(to: .bookDetail(book: book))
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
        .scrollDismissesKeyboard(.immediately)
    }
}
