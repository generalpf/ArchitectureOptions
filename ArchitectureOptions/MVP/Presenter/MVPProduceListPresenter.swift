//
//  MVPProduceListPresenter.swift
//  ArchitectureOptions
//

import Foundation

extension MVP {
    final class ProduceListPresenter {
        enum SortOrder {
            case ascending
            case descending

            var toggled: SortOrder {
                self == .ascending ? .descending : .ascending
            }
        }

        enum Filter: CaseIterable, Identifiable {
            case fruit
            case vegetables
            case all

            var id: Self { self }

            var title: String {
                switch self {
                case .fruit: "Fruit"
                case .vegetables: "Vegetables"
                case .all: "All"
                }
            }

            func includes(_ kind: Produce.Kind) -> Bool {
                switch self {
                case .fruit: kind == .fruit
                case .vegetables: kind == .vegetable
                case .all: true
                }
            }
        }

        weak var view: ProduceListViewProtocol?

        private(set) var sortOrder: SortOrder = .ascending
        private(set) var filter: Filter = .all
        private var produce: [Produce] = []

        private let repository: ProduceRepository

        init(repository: ProduceRepository = StaticProduceRepository()) {
            self.repository = repository
        }

        // MARK: View events

        func viewDidLoad() {
            produce = repository.fetchProduce()
            render()
        }

        func didTapSort() {
            sortOrder = sortOrder.toggled
            render()
        }

        func didSelectFilter(_ filter: Filter) {
            self.filter = filter
            render()
        }

        // MARK: Rendering

        private func render() {
            let sorted = produce.filter { filter.includes($0.kind) }.sorted { lhs, rhs in
                let result = lhs.name.localizedStandardCompare(rhs.name)
                return sortOrder == .ascending
                    ? result == .orderedAscending
                    : result == .orderedDescending
            }

            view?.display(rows: sorted.map {
                ProduceRowViewModel(id: $0.id, title: $0.name, subtitle: $0.kind.rawValue, emoji: $0.emoji)
            })
            view?.display(
                sortButtonTitle: sortOrder == .ascending ? "A → Z" : "Z → A",
                systemImage: sortOrder == .ascending ? "arrow.up" : "arrow.down"
            )
            view?.display(selectedFilter: filter)
        }
    }
}
