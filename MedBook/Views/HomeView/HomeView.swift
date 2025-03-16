//
//  HomeView.swift
//  MedBook
//
//  Created by Sai Prithvi on 16/03/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var router: RouterViewModel

    var body: some View {
        VStack {
            Text("Home Screen")
            Button("Go to Detail") {
                router.navigate(to: .detail("Hello from Home!"))
            }
            Button("Go to Settings") {
                router.navigate(to: .settings)
            }
        }
        .navigationTitle("Home")
    }
}

struct DetailView: View {
    let message: String
    @EnvironmentObject var router: RouterViewModel

    var body: some View {
        VStack {
            Text("Detail Screen")
            Text(message)
            Button("Go Back") {
                router.goBack()
            }
        }
        .navigationTitle("Detail")
    }
}

struct SettingsView: View {
    @EnvironmentObject var router: RouterViewModel

    var body: some View {
        VStack {
            Text("Settings Screen")
            Button("Reset Navigation") {
                router.resetNavigation()
            }
        }
        .navigationTitle("Settings")
    }
}
