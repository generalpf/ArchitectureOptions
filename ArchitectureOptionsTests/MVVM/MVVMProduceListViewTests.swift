//
//  MVVMProduceListViewTests.swift
//  ArchitectureOptionsTests
//
//  Verifies the View forwards user actions to its ViewModel.
//

import SwiftUI
import Testing
import ViewInspector
@testable import ArchitectureOptions

@MainActor
struct MVVMProduceListViewTests {
    private struct StubRepository: MVVM.ProduceRepository {
        func fetchProduce() -> [MVVM.Produce] {
            [
                MVVM.Produce(name: "Apple", kind: .fruit, emoji: "🍎"),
                MVVM.Produce(name: "Carrot", kind: .vegetable, emoji: "🥕"),
            ]
        }
    }

    @Test func taskAsksViewModelToLoad() async throws {
        let viewModel = MVVM.ProduceListViewModel(repository: StubRepository())
        let sut = MVVM.ProduceListView(viewModel: viewModel)

        try await sut.inspect().find(ViewType.List.self).callTask()

        #expect(viewModel.visibleProduce.map(\.name) == ["Apple", "Carrot"])
    }

    @Test func tappingSortTogglesViewModelSortOrder() throws {
        let viewModel = MVVM.ProduceListViewModel(repository: StubRepository())
        let sut = MVVM.ProduceListView(viewModel: viewModel)

        try sut.inspect().find(viewWithAccessibilityIdentifier: "sortButton").button().tap()

        #expect(viewModel.sortOrder == .descending)
    }

    @Test func selectingFilterUpdatesViewModelFilter() throws {
        let viewModel = MVVM.ProduceListViewModel(repository: StubRepository())
        let sut = MVVM.ProduceListView(viewModel: viewModel)

        try sut.inspect().find(viewWithAccessibilityIdentifier: "filterPicker").picker()
            .select(value: MVVM.ProduceListViewModel.Filter.fruit)

        #expect(viewModel.filter == .fruit)
    }
}
