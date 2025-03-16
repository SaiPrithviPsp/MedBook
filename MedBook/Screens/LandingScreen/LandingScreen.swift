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
        VStack(alignment: .leading) {
            Text("MedBook")
                .font(.title2)
                .fontWeight(.bold)
                .padding()
            Spacer()
            HStack {
                PrimaryCta(text: "Singup") {
                    router.navigate(to: .signup)
                }
                PrimaryCta(text: "Login") {
                    router.navigate(to: .login)
                }
            }
            .padding()
        }
        .background(Color.white)
        .navigationBarBackButtonHidden()
    }
}
