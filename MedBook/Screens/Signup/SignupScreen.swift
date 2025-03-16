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
        VStack(alignment: .leading, spacing: 16) {
            Text("Welcome")
                .font(.title)
                .fontWeight(.bold)
            Text("Sign up to continue")
                .foregroundColor(.gray)
            
            VStack(alignment: .leading, spacing: 4) {
                TextField("Email", text: $viewModel.email)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                if let error = viewModel.emailError {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                if let error = viewModel.passwordError {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            
            PrimaryCta(text: "Sign up", isEnabled: viewModel.isPrimaryCtaEnabled) {
                viewModel.didTapSignUpButton()
            }
            .padding(.top, 8)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Sign up")
        .onAppear {
            viewModel.onViewAppear()
        }
    }
}
