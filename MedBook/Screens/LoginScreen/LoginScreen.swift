//
//  LoginView.swift
//  MedBook
//
//  Created by Sai Prithvi on 16/03/25.
//

import SwiftUI

struct LoginScreen: View {
    @EnvironmentObject var authHelper: AuthHelper

    var body: some View {
        VStack {
            Text("Login Screen")
            Button("Login") {
                authHelper.login() // Automatically switches to HomeView via SplashScreen
            }
        }
        .navigationTitle("Login")
    }
}

