//
//  ContentView.swift
//  ArchitectureOptions
//
//  Created by Ryan Walberg on 2026-09-25.
//

import ComposableArchitecture
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
                NavigationLink("TCA") {
                    TCA.ProduceListView(
                        store: Store(initialState: TCA.ProduceListFeature.State()) {
                            TCA.ProduceListFeature()
                        }
                    )
                }
            }
            .navigationTitle("Architectures")
        }
    }
}

#Preview {
    ContentView()
}
