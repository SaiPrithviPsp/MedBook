//
//  LoaderScreen.swift
//  MedBook
//
//  Created by Sai Prithvi on 16/03/25.
//

import SwiftUI

struct LoaderView: View {
    var body: some View {
        VStack {
            ProgressView("Checking Authentication...")
                .progressViewStyle(CircularProgressViewStyle())
                .padding()
        }
    }
}
