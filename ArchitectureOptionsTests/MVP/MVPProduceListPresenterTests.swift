//
//  MVPProduceListPresenterTests.swift
//  ArchitectureOptionsTests
//

import Testing
@testable import ArchitectureOptions

@MainActor
struct MVPProduceListPresenterTests {
    private struct StubRepository: MVP.ProduceRepository {
        func fetchProduce() -> [MVP.Produce] {
            [
                MVP.Produce(name: "banana", kind: .fruit, emoji: "🍌"),
                MVP.Produce(name: "Carrot", kind: .vegetable, emoji: "🥕"),
                MVP.Produce(name: "Apple", kind: .fruit, emoji: "🍎"),
            ]
        }
    }

    private final class SpyView: MVP.ProduceListViewProtocol {
        var rows: [MVP.ProduceRowViewModel] = []
        var sortButtonTitle = ""
        var selectedFilter: MVP.ProduceListPresenter.Filter?

        func display(rows: [MVP.ProduceRowViewModel]) { self.rows = rows }
        func display(sortButtonTitle: String, systemImage: String) { self.sortButtonTitle = sortButtonTitle }
        func display(selectedFilter: MVP.ProduceListPresenter.Filter) { self.selectedFilter = selectedFilter }
    }

    @Test func viewDidLoadDisplaysAscending() {
        let view = SpyView()
        let presenter = MVP.ProduceListPresenter(repository: StubRepository())
        presenter.view = view

        presenter.viewDidLoad()

        #expect(view.rows.map(\.title) == ["Apple", "banana", "Carrot"])
        #expect(view.rows.map(\.subtitle) == ["Fruit", "Fruit", "Vegetable"])
        #expect(view.sortButtonTitle == "A → Z")
        #expect(view.selectedFilter == .all)
    }

    @Test func tapSortDisplaysDescending() {
        let view = SpyView()
        let presenter = MVP.ProduceListPresenter(repository: StubRepository())
        presenter.view = view
        presenter.viewDidLoad()

        presenter.didTapSort()

        #expect(view.rows.map(\.title) == ["Carrot", "banana", "Apple"])
        #expect(view.sortButtonTitle == "Z → A")
    }

    @Test func tapSortTwiceReturnsToAscending() {
        let view = SpyView()
        let presenter = MVP.ProduceListPresenter(repository: StubRepository())
        presenter.view = view
        presenter.viewDidLoad()

        presenter.didTapSort()
        presenter.didTapSort()

        #expect(view.rows.map(\.title) == ["Apple", "banana", "Carrot"])
        #expect(view.sortButtonTitle == "A → Z")
    }

    @Test func selectFruitDisplaysOnlyFruit() {
        let view = SpyView()
        let presenter = MVP.ProduceListPresenter(repository: StubRepository())
        presenter.view = view
        presenter.viewDidLoad()

        presenter.didSelectFilter(.fruit)

        #expect(view.rows.map(\.title) == ["Apple", "banana"])
        #expect(view.selectedFilter == .fruit)
    }

    @Test func filterIsKeptWhenSorting() {
        let view = SpyView()
        let presenter = MVP.ProduceListPresenter(repository: StubRepository())
        presenter.view = view
        presenter.viewDidLoad()

        presenter.didSelectFilter(.fruit)
        presenter.didTapSort()

        #expect(view.rows.map(\.title) == ["banana", "Apple"])
        #expect(view.selectedFilter == .fruit)
    }
}
