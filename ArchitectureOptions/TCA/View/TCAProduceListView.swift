//
//  TCAProduceListView.swift
//  ArchitectureOptions
//

import ComposableArchitecture
import SwiftUI

extension TCA {
    struct ProduceListView: View {
        let store: StoreOf<ProduceListFeature>

        var body: some View {
            List(store.produce) { item in
                ProduceRow(produce: item)
            }
            .animation(.default, value: store.sortOrder)
            .navigationTitle("Produce (TCA)")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        store.send(.sortButtonTapped)
                    } label: {
                        Label(store.sortButtonTitle, systemImage: store.sortButtonSystemImage)
                            .labelStyle(.titleAndIcon)
                    }
                    .accessibilityIdentifier("sortButton")
                }
            }
            .task {
                await store.send(.task).finish()
            }
        }
    }

    struct ProduceRow: View {
        let produce: Produce

        var body: some View {
            HStack {
                Text(produce.emoji)
                    .font(.largeTitle)
                VStack(alignment: .leading) {
                    Text(produce.name)
                        .font(.headline)
                    Text(produce.kind.rawValue)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        TCA.ProduceListView(
            store: Store(initialState: TCA.ProduceListFeature.State()) {
                TCA.ProduceListFeature()
            }
        )
    }
}
