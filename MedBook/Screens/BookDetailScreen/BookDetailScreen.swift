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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Book details")
            Spacer()
        }
        .background(Color.primaryBgColor)
        .navigationBarHidden(true)
    }
}
