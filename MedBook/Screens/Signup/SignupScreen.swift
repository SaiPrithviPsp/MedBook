//
//  SignupScreen.swift
//  MedBook
//
//  Created by Sai Prithvi on 16/03/25.
//

import SwiftUI

struct SignupScreen: View {
    @StateObject var viewModel = SignUpViewModel()
    @EnvironmentObject var router: RouterViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Welcome")
                    .font(.title)
                    .fontWeight(.bold)
                Text("Sign up to continue")
                    .foregroundColor(.gray)
                
                VStack(alignment: .leading, spacing: 16) {
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
                        
                        if let signUpError = viewModel.signUpError {
                            Text(signUpError)
                                .foregroundColor(.red)
                                .padding(.vertical, 8)
                        }
                        
                        // Password requirements
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password requirements:")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            HStack {
                                Image(systemName: viewModel.hasMinLength ? "checkmark.square.fill" : "square")
                                    .foregroundColor(viewModel.hasMinLength ? .green : .gray)
                                Text("At least 8 characters")
                                    .font(.caption)
                            }
                            
                            HStack {
                                Image(systemName: viewModel.hasUppercase ? "checkmark.square.fill" : "square")
                                    .foregroundColor(viewModel.hasUppercase ? .green : .gray)
                                Text("Must contain an uppercase letter")
                                    .font(.caption)
                            }
                            
                            HStack {
                                Image(systemName: viewModel.hasSpecialCharacter ? "checkmark.square.fill" : "square")
                                    .foregroundColor(viewModel.hasSpecialCharacter ? .green : .gray)
                                Text("Contains a special character")
                                    .font(.caption)
                            }
                        }
                        .padding(.top, 8)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        if !viewModel.countryList.isEmpty {
                            Picker("Country", selection: $viewModel.selectedCountry) {
                                ForEach(viewModel.countryList, id: \.self) { country in
                                    Text(country)
                                        .tag(country)
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(height: 150)
                        }
                    }
                }
                .padding(.bottom, 16)
                
                PrimaryCta(text: "Sign up", rightIcon: Image(systemName: "arrow.right"), isEnabled: viewModel.isPrimaryCtaEnabled) {
                    viewModel.didTapSignUpButton()
                }
                .padding()
            }
            .padding()
        }
        .background(Color.primaryBgColor)
        .navigationTitle("Sign up")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    router.goBack()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primary)
                }
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear {
            viewModel.onViewAppear()
        }
        .onReceive(viewModel.nextNavigationStep) { newValue in
            router.navigate(to: newValue)
        }
    }
}

#Preview {
    SignupScreen()
}
