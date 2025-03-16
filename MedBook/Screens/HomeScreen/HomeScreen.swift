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
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
            .padding(.horizontal)
            
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
