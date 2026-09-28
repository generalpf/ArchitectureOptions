//
//  MVVMProduceListViewModelTests.swift
//  ArchitectureOptionsTests
//

import Testing
@testable import ArchitectureOptions

@MainActor
struct ProduceListViewModelTests {
    private struct StubRepository: MVVM.ProduceRepository {
        func fetchProduce() -> [MVVM.Produce] {
            [
                MVVM.Produce(name: "banana", kind: .fruit, emoji: "🍌"),
                MVVM.Produce(name: "Carrot", kind: .vegetable, emoji: "🥕"),
                MVVM.Produce(name: "Apple", kind: .fruit, emoji: "🍎"),
            ]
        }
    }

    @Test func sortsAlphabeticallyByDefault() {
        let viewModel = MVVM.ProduceListViewModel(repository: StubRepository())
        viewModel.load()

        #expect(viewModel.sortOrder == .ascending)
        #expect(viewModel.visibleProduce.map(\.name) == ["Apple", "banana", "Carrot"])
    }

    @Test func toggleSortsReverseAlphabetically() {
        let viewModel = MVVM.ProduceListViewModel(repository: StubRepository())
        viewModel.load()

        viewModel.toggleSortOrder()

        #expect(viewModel.sortOrder == .descending)
        #expect(viewModel.visibleProduce.map(\.name) == ["Carrot", "banana", "Apple"])
    }

    @Test func toggleTwiceReturnsToAlphabetical() {
        let viewModel = MVVM.ProduceListViewModel(repository: StubRepository())
        viewModel.load()

        viewModel.toggleSortOrder()
        viewModel.toggleSortOrder()

        #expect(viewModel.visibleProduce.map(\.name) == ["Apple", "banana", "Carrot"])
    }

    @Test func defaultsToAllFilter() {
        let viewModel = MVVM.ProduceListViewModel(repository: StubRepository())
        viewModel.load()

        #expect(viewModel.filter == .all)
        #expect(viewModel.visibleProduce.count == 3)
    }

    @Test func filtersToFruit() {
        let viewModel = MVVM.ProduceListViewModel(repository: StubRepository())
        viewModel.load()

        viewModel.filter = .fruit

        #expect(viewModel.visibleProduce.map(\.name) == ["Apple", "banana"])
    }

    @Test func filtersToVegetablesAndKeepsSortOrder() {
        let viewModel = MVVM.ProduceListViewModel(repository: StubRepository())
        viewModel.load()

        viewModel.toggleSortOrder()
        viewModel.filter = .vegetables

        #expect(viewModel.visibleProduce.map(\.name) == ["Carrot"])
        #expect(viewModel.sortOrder == .descending)
    }
}
