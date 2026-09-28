//
//  MVVMProduceListViewModel.swift
//  ArchitectureOptions
//

import Foundation
import Observation

extension MVVM {
    @Observable
    final class ProduceListViewModel {
        enum SortOrder {
            case ascending
            case descending

            mutating func toggle() {
                self = (self == .ascending) ? .descending : .ascending
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

        private(set) var sortOrder: SortOrder = .ascending
        var filter: Filter = .all
        private var produce: [Produce] = []

        private let repository: ProduceRepository

        init(repository: ProduceRepository = StaticProduceRepository()) {
            self.repository = repository
        }

        var visibleProduce: [Produce] {
            produce
                .filter { filter.includes($0.kind) }
                .sorted { lhs, rhs in
                    let result = lhs.name.localizedStandardCompare(rhs.name)
                    return sortOrder == .ascending
                        ? result == .orderedAscending
                        : result == .orderedDescending
                }
        }

        var sortButtonTitle: String {
            sortOrder == .ascending ? "A → Z" : "Z → A"
        }

        var sortButtonSystemImage: String {
            sortOrder == .ascending ? "arrow.up" : "arrow.down"
        }

        func load() {
            produce = repository.fetchProduce()
        }

        func toggleSortOrder() {
            sortOrder.toggle()
        }
    }
}
