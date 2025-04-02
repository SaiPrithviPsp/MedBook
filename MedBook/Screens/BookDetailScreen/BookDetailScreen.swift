//
//  BookDetailScreen.swift
//  MedBook
//
//  Created by Sai Prithvi on 02/04/25.
//

import SwiftUI

struct BookDetailScreen: View {
    @EnvironmentObject var router: RouterViewModel
    @StateObject private var viewModel = BookDetailViewModel(key: "OL49488W")
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Book details")
            Spacer()
        }
        .background(Color.primaryBgColor)
        .navigationBarHidden(true)
    }
}
