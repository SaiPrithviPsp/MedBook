//
//  LoginView.swift
//  MedBook
//
//  Created by Sai Prithvi on 16/03/25.
//

import SwiftUI

struct LoginScreen: View {
    @EnvironmentObject var authHelper: AuthHelper
    @StateObject private var viewModel = LoginViewModel()
    @EnvironmentObject var router: RouterViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Welcome Back")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Login to continue")
                .foregroundStyle(Color(.systemGray))
                .font(.title3)
                .fontWeight(.bold)
                .padding(.bottom, 30)
            
            VStack(alignment: .leading, spacing: 8) {
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                
                if let error = viewModel.emailError {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if let error = viewModel.passwordError {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            
            Spacer()
            
            PrimaryCta(text: "Login", rightIcon: Image(systemName: "arrow.right"), isEnabled: viewModel.isPrimaryCtaEnabled) {
                viewModel.didTapLoginButton()
            }
            .padding()
        }
        .padding()
        .background(Color.white)
        .onReceive(viewModel.nextNavigationStep) { newValue in
            router.navigate(to: newValue)
        }
    }
}

#Preview {
    LoginScreen()
}
