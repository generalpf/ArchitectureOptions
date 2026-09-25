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
            }
            .navigationTitle("Architectures")
        }
    }
}

#Preview {
    ContentView()
}
