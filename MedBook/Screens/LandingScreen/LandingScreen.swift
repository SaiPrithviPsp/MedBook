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
        VStack {
            Text("Landing screen")
            Button("login") {
                router.navigate(to: .login)
            }
            Button("sign in") {
                router.navigate(to: .signup)
            }
        }
        .navigationBarBackButtonHidden()
    }
}
