//
//  MVPProduceListView.swift
//  ArchitectureOptions
//

import SwiftUI

extension MVP {
    struct ProduceListView: View {
        @State private var display: ProduceListDisplay
        @State private var presenter: ProduceListPresenter

        init(repository: ProduceRepository = StaticProduceRepository()) {
            let display = ProduceListDisplay()
            let presenter = ProduceListPresenter(repository: repository)
            presenter.view = display
            _display = State(initialValue: display)
            _presenter = State(initialValue: presenter)
        }

        var body: some View {
            List(display.rows) { row in
                ProduceRow(row: row)
            }
            .animation(.default, value: display.rows)
            .safeAreaInset(edge: .top) {
                Picker("Filter", selection: Binding(
                    get: { display.selectedFilter },
                    set: { presenter.didSelectFilter($0) }
                )) {
                    ForEach(ProduceListPresenter.Filter.allCases) { filter in
                        Text(filter.title).tag(filter)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
            .navigationTitle("Produce (MVP)")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        presenter.didTapSort()
                    } label: {
                        Label(display.sortButtonTitle, systemImage: display.sortButtonSystemImage)
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
        MVP.ProduceListView()
    }
}
