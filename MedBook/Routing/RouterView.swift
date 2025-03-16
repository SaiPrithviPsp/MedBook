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
                        HomeView()
                    case .detail(let message):
                        DetailView(message: message)
                    case .settings:
                        SettingsView()
                    case .login:
                        LoginView()
                    }
                }
        }
        .environmentObject(router)
    }
}
