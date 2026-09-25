//
//  ProduceListView.swift
//  ArchitectureOptions
//

import SwiftUI

extension MVVM {
    struct ProduceListView: View {
        @State private var viewModel: ProduceListViewModel

        init(viewModel: ProduceListViewModel = ProduceListViewModel()) {
            _viewModel = State(initialValue: viewModel)
        }

        var body: some View {
            List(viewModel.sortedProduce) { item in
                ProduceRow(produce: item)
            }
            .animation(.default, value: viewModel.sortOrder)
            .navigationTitle("Produce (MVVM)")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        viewModel.toggleSortOrder()
                    } label: {
                        Label(viewModel.sortButtonTitle, systemImage: viewModel.sortButtonSystemImage)
                            .labelStyle(.titleAndIcon)
                    }
                    .accessibilityIdentifier("sortButton")
                }
            }
            .task {
                viewModel.load()
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
        MVVM.ProduceListView()
    }
}
