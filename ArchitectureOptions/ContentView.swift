//
//  ContentView.swift
//  ArchitectureOptions
//
//  Created by Ryan Walberg on 2026-09-25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("MVVM") {
                    MVVM.ProduceListView()
                }
                NavigationLink("VIPER") {
                    VIPER.ProduceListRouter.createModule()
                }
            }
            .navigationTitle("Architectures")
        }
    }
}

#Preview {
    ContentView()
}
