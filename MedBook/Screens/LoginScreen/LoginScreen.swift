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
            
            Button(action: {
                viewModel.didTapLoginButton()
            }) {
                Text("Login")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.isPrimaryCtaEnabled ? Color.blue : Color.gray)
                    .cornerRadius(10)
            }
            .disabled(!viewModel.isPrimaryCtaEnabled)
            
            Spacer()
        }
        .padding()
        .onReceive(viewModel.nextNavigationStep) { newValue in
            router.navigate(to: newValue)
        }
    }
}

#Preview {
    LoginScreen()
}
