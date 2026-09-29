//
//  MVPProduceListView.swift
//  ArchitectureOptions
//

import SwiftUI

extension MVP {
    struct ProduceListView: View {
        /// Observed: the Presenter pushes values into it and the view redraws.
        @StateObject private var display: ProduceListDisplay
        /// Not observed, only called. `@State` just keeps the same instance alive across re-inits.
        @State private var presenter: ProduceListPresenter

        init(repository: ProduceRepository = StaticProduceRepository()) {
            self.init(presenter: ProduceListPresenter(repository: repository), display: ProduceListDisplay())
        }

        init(presenter: ProduceListPresenter, display: ProduceListDisplay) {
            presenter.view = display
            _display = StateObject(wrappedValue: display)
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
                .accessibilityIdentifier("filterPicker")
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
    NavigationView {
        MVP.ProduceListView()
    }
}
