//
//  SplashView.swift
//  MedBook
//
//  Created by Sai Prithvi on 16/03/25.
//

import SwiftUI

struct SplashScreen: View {
    @ObservedObject var authHelper = AuthHelper.shared
    @EnvironmentObject var router: RouterViewModel
    
    var body: some View {
            VStack {
                ProgressView("Checking Authentication...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            }
            .onAppear {
                if authHelper.isUserLoggedIn() {
                    router.navigate(to: .home)
                } else {
                    router.navigate(to: .landing)
                }
            }
    }
}
