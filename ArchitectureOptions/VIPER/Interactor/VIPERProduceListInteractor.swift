//
//  VIPERProduceListInteractor.swift
//  ArchitectureOptions
//

import Foundation

extension VIPER {
    final class ProduceListInteractor: ProduceListInteractorInput {
        weak var output: ProduceListInteractorOutput?

        private let dataSource: ProduceDataSource

        init(dataSource: ProduceDataSource = StaticProduceDataSource()) {
            self.dataSource = dataSource
        }

        func loadProduce(sortedBy order: SortOrder, filteredBy filter: ProduceFilter) {
            let filtered = dataSource.allProduce().filter { produce in
                switch filter {
                case .fruit: produce.kind == .fruit
                case .vegetables: produce.kind == .vegetable
                case .all: true
                }
            }
            let sorted = filtered.sorted { lhs, rhs in
                let result = lhs.name.localizedStandardCompare(rhs.name)
                return order == .ascending
                    ? result == .orderedAscending
                    : result == .orderedDescending
            }
            output?.didLoadProduce(sorted)
        }
    }
}
