//
//  VIPERProduceListView.swift
//  ArchitectureOptions
//

import SwiftUI

extension VIPER {
    struct ProduceListView: View {
        @State private var presenter: ProduceListPresenter

        init(presenter: ProduceListPresenter) {
            _presenter = State(initialValue: presenter)
        }

        var body: some View {
            List(presenter.rows) { row in
                ProduceRow(row: row)
            }
            .animation(.default, value: presenter.rows)
            .navigationTitle(presenter.title)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        presenter.didTapSort()
                    } label: {
                        Label(presenter.sortButtonTitle, systemImage: presenter.sortButtonSystemImage)
                            .labelStyle(.titleAndIcon)
                    }
                    .accessibilityIdentifier("sortButton")
                }
            }
            .task {
                presenter.viewDidLoad()
            }
        }
    }

    struct ProduceRow: View {
        let row: ProduceRowViewModel

        var body: some View {
            HStack {
                Text(row.emoji)
                    .font(.largeTitle)
                VStack(alignment: .leading) {
                    Text(row.title)
                        .font(.headline)
                    Text(row.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        VIPER.ProduceListRouter.createModule()
    }
}
