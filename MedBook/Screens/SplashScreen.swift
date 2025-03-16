//
//  SplashView.swift
//  MedBook
//
//  Created by Sai Prithvi on 16/03/25.
//

import SwiftUI

struct SplashScreen: View {
    @ObservedObject var authHelper = AuthHelper.shared

    var body: some View {
        Group {
            if let isLoggedIn = authHelper.isLoggedIn {
                if isLoggedIn {
                    HomeScreen()
                } else {
                    LoginView()
                }
            } else {
                // Show Loader while checking authentication
                VStack {
                    ProgressView("Checking Authentication...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                }
                .onAppear {
                    authHelper.checkAuthenticationStatus()
                }
            }
        }
    }
}
