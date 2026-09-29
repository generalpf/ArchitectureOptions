//
//  MVVMProduceListView.swift
//  ArchitectureOptions
//

import SwiftUI

extension MVVM {
    struct ProduceListView: View {
        @StateObject private var viewModel: ProduceListViewModel

        /// `@autoclosure` keeps creation lazy: `StateObject` only builds the view model
        /// the first time this view appears, not on every re-init of the struct.
        init(viewModel: @autoclosure @escaping () -> ProduceListViewModel = ProduceListViewModel()) {
            _viewModel = StateObject(wrappedValue: viewModel())
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
                .accessibilityIdentifier("filterPicker")
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
    NavigationView {
        MVVM.ProduceListView()
    }
}
