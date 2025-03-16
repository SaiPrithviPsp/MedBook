//
//  SignupScreen.swift
//  MedBook
//
//  Created by Sai Prithvi on 16/03/25.
//

import SwiftUI

struct SignupScreen: View {
    @EnvironmentObject var authHelper: AuthHelper

    var body: some View {
        VStack {
            Text("Signup Screen")
            Button("Sign up") {
                authHelper.login() // Automatically switches to HomeView via SplashScreen
            }
        }
        .navigationTitle("Sign up")
    }
}
