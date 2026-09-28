//
//  MVVMProduceListView.swift
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
            List(viewModel.visibleProduce) { item in
                ProduceRow(produce: item)
            }
            .animation(.default, value: viewModel.visibleProduce)
            .safeAreaInset(edge: .top) {
                Picker("Filter", selection: $viewModel.filter) {
                    ForEach(ProduceListViewModel.Filter.allCases) { filter in
                        Text(filter.title).tag(filter)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
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
