//
//  VIPERProduceListTests.swift
//  ArchitectureOptionsTests
//

import Testing
@testable import ArchitectureOptions

@MainActor
struct VIPERProduceListInteractorTests {
    private struct StubDataSource: VIPER.ProduceDataSource {
        func allProduce() -> [VIPER.Produce] {
            [
                VIPER.Produce(name: "banana", kind: .fruit, emoji: "🍌"),
                VIPER.Produce(name: "Carrot", kind: .vegetable, emoji: "🥕"),
                VIPER.Produce(name: "Apple", kind: .fruit, emoji: "🍎"),
            ]
        }
    }

    private final class SpyOutput: VIPER.ProduceListInteractorOutput {
        var loaded: [VIPER.Produce] = []
        func didLoadProduce(_ produce: [VIPER.Produce]) { loaded = produce }
    }

    @Test func sortsAscending() {
        let interactor = VIPER.ProduceListInteractor(dataSource: StubDataSource())
        let output = SpyOutput()
        interactor.output = output

        interactor.loadProduce(sortedBy: .ascending)

        #expect(output.loaded.map(\.name) == ["Apple", "banana", "Carrot"])
    }

    @Test func sortsDescending() {
        let interactor = VIPER.ProduceListInteractor(dataSource: StubDataSource())
        let output = SpyOutput()
        interactor.output = output

        interactor.loadProduce(sortedBy: .descending)

        #expect(output.loaded.map(\.name) == ["Carrot", "banana", "Apple"])
    }
}

@MainActor
struct VIPERProduceListPresenterTests {
    private final class SpyInteractor: VIPER.ProduceListInteractorInput {
        var requestedOrders: [VIPER.SortOrder] = []
        func loadProduce(sortedBy order: VIPER.SortOrder) { requestedOrders.append(order) }
    }

    @Test func viewDidLoadRequestsAscending() {
        let interactor = SpyInteractor()
        let presenter = VIPER.ProduceListPresenter(interactor: interactor, router: VIPER.ProduceListRouter())

        presenter.viewDidLoad()

        #expect(interactor.requestedOrders == [.ascending])
    }

    @Test func tapSortTogglesAndRequestsNewOrder() {
        let interactor = SpyInteractor()
        let presenter = VIPER.ProduceListPresenter(interactor: interactor, router: VIPER.ProduceListRouter())

        presenter.didTapSort()
        presenter.didTapSort()

        #expect(interactor.requestedOrders == [.descending, .ascending])
        #expect(presenter.sortOrder == .ascending)
    }

    @Test func mapsEntitiesToRows() {
        let presenter = VIPER.ProduceListPresenter(interactor: SpyInteractor(), router: VIPER.ProduceListRouter())

        presenter.didLoadProduce([VIPER.Produce(name: "Kiwi", kind: .fruit, emoji: "🥝")])

        #expect(presenter.rows.map(\.title) == ["Kiwi"])
        #expect(presenter.rows.map(\.subtitle) == ["Fruit"])
    }
}
