//
//  MVPProduceListViewTests.swift
//  ArchitectureOptionsTests
//
//  Verifies the View forwards user actions to its Presenter.
//

import SwiftUI
import Testing
import ViewInspector
@testable import ArchitectureOptions

@MainActor
struct MVPProduceListViewTests {
    private struct StubRepository: MVP.ProduceRepository {
        func fetchProduce() -> [MVP.Produce] {
            [
                MVP.Produce(name: "Apple", kind: .fruit, emoji: "🍎"),
                MVP.Produce(name: "Carrot", kind: .vegetable, emoji: "🥕"),
            ]
        }
    }

    private func makeSUT() -> (MVP.ProduceListView, MVP.ProduceListPresenter, MVP.ProduceListDisplay) {
        let presenter = MVP.ProduceListPresenter(repository: StubRepository())
        let display = MVP.ProduceListDisplay()
        return (MVP.ProduceListView(presenter: presenter, display: display), presenter, display)
    }

    @Test func taskCallsPresenterViewDidLoad() async throws {
        let (sut, _, display) = makeSUT()

        try await sut.inspect().find(ViewType.List.self).callTask()

        #expect(display.rows.map(\.title) == ["Apple", "Carrot"])
    }

    @Test func tappingSortCallsPresenterDidTapSort() throws {
        let (sut, presenter, _) = makeSUT()

        try sut.inspect().find(viewWithAccessibilityIdentifier: "sortButton").button().tap()

        #expect(presenter.sortOrder == .descending)
    }

    @Test func selectingFilterCallsPresenterDidSelectFilter() throws {
        let (sut, presenter, _) = makeSUT()

        try sut.inspect().find(viewWithAccessibilityIdentifier: "filterPicker").picker()
            .select(value: MVP.ProduceListPresenter.Filter.vegetables)

        #expect(presenter.filter == .vegetables)
    }
}
