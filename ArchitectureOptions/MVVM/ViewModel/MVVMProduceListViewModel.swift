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

        private(set) var sortOrder: SortOrder = .ascending
        private var produce: [Produce] = []

        private let repository: ProduceRepository

        init(repository: ProduceRepository = StaticProduceRepository()) {
            self.repository = repository
        }

        var sortedProduce: [Produce] {
            produce.sorted { lhs, rhs in
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
