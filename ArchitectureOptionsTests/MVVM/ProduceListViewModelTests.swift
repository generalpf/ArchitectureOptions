//
//  ProduceListViewModelTests.swift
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
        #expect(viewModel.sortedProduce.map(\.name) == ["Apple", "banana", "Carrot"])
    }

    @Test func toggleSortsReverseAlphabetically() {
        let viewModel = MVVM.ProduceListViewModel(repository: StubRepository())
        viewModel.load()

        viewModel.toggleSortOrder()

        #expect(viewModel.sortOrder == .descending)
        #expect(viewModel.sortedProduce.map(\.name) == ["Carrot", "banana", "Apple"])
    }

    @Test func toggleTwiceReturnsToAlphabetical() {
        let viewModel = MVVM.ProduceListViewModel(repository: StubRepository())
        viewModel.load()

        viewModel.toggleSortOrder()
        viewModel.toggleSortOrder()

        #expect(viewModel.sortedProduce.map(\.name) == ["Apple", "banana", "Carrot"])
    }
}
