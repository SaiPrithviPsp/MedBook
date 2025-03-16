//
//  RouterView.swift
//  MedBook
//
//  Created by Sai Prithvi on 16/03/25.
//

import SwiftUI

struct RouterView: View {
    @ObservedObject var router = RouterViewModel()

    var body: some View {
        NavigationStack(path: $router.path) {
            SplashScreen() // Always starts with SplashScreen
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                        case .home:
                            HomeScreen()
                        case .login:
                            LoginScreen()
                        case .landing:
                            LandingScreen()
                        case .signup:
                            SignupScreen()
                    }
                }
        }
        .environmentObject(router)
    }
}
