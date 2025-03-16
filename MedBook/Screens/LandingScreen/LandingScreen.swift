//
//  LandingScreen.swift
//  MedBook
//
//  Created by Sai Prithvi on 16/03/25.
//

import SwiftUI

struct LandingScreen: View {
    @EnvironmentObject var router: RouterViewModel
    
    var body: some View {
        VStack(alignment: .center) {
            Text("MedBook")
                .font(.title2)
                .fontWeight(.bold)
                .padding()
                .padding(.top, 80)
            Spacer()
            Image(systemName: "book")
                .resizable()
                .frame(width: 120, height: 100)
            Spacer()
            HStack {
                PrimaryCta(text: "Sign up") {
                    router.navigate(to: .signup)
                }
                Spacer().frame(width: 20)
                PrimaryCta(text: "Login") {
                    router.navigate(to: .login)
                }
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
        .background(Color.primaryBgColor)
        .navigationBarBackButtonHidden()
    }
}
