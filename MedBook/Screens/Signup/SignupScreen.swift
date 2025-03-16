//
//  SignupScreen.swift
//  MedBook
//
//  Created by Sai Prithvi on 16/03/25.
//

import SwiftUI

struct SignupScreen: View {
    @EnvironmentObject var authHelper: AuthHelper
    @StateObject var viewModel = SignUpViewModel()
    
    var body: some View {
        VStack {
            Text("Welcome")
            Text("Sign up to continue")
            
            TextField("Email", text: $viewModel.email)
                .autocapitalization(.none)
            
            SecureField("Password", text: $viewModel.password)
            
            PrimaryCta(text: "Sign up", isEnabled: viewModel.isPrimaryCtaEnabled) {
                viewModel.didTapSignUpButton()
            }
            .padding()
        }
        .navigationTitle("Sign up")
        .onAppear {
            viewModel.onViewAppear()
        }
    }
}
