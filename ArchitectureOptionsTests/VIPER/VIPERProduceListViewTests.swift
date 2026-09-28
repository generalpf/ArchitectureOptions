//
//  VIPERProduceListViewTests.swift
//  ArchitectureOptionsTests
//
//  Verifies the View forwards user actions to its Presenter.
//

import SwiftUI
import Testing
import ViewInspector
@testable import ArchitectureOptions

@MainActor
struct VIPERProduceListViewTests {
    private final class SpyInteractor: VIPER.ProduceListInteractorInput {
        var requests: [(VIPER.SortOrder, VIPER.ProduceFilter)] = []
        func loadProduce(sortedBy order: VIPER.SortOrder, filteredBy filter: VIPER.ProduceFilter) {
            requests.append((order, filter))
        }
    }

    private func makeSUT() -> (VIPER.ProduceListView, VIPER.ProduceListPresenter, SpyInteractor) {
        let interactor = SpyInteractor()
        let presenter = VIPER.ProduceListPresenter(interactor: interactor, router: VIPER.ProduceListRouter())
        return (VIPER.ProduceListView(presenter: presenter), presenter, interactor)
    }

    @Test func taskCallsPresenterViewDidLoad() async throws {
        let (sut, _, interactor) = makeSUT()

        try await sut.inspect().find(ViewType.List.self).callTask()

        #expect(interactor.requests.count == 1)
    }

    @Test func tappingSortCallsPresenterDidTapSort() throws {
        let (sut, presenter, _) = makeSUT()

        try sut.inspect().find(viewWithAccessibilityIdentifier: "sortButton").button().tap()

        #expect(presenter.sortOrder == .descending)
    }

    @Test func selectingFilterCallsPresenterDidSelectFilter() throws {
        let (sut, presenter, _) = makeSUT()

        try sut.inspect().find(viewWithAccessibilityIdentifier: "filterPicker").picker()
            .select(value: VIPER.ProduceFilter.fruit)

        #expect(presenter.filter == .fruit)
    }
}
