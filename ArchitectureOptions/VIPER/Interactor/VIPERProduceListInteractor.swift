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

        func loadProduce(sortedBy order: SortOrder) {
            let sorted = dataSource.allProduce().sorted { lhs, rhs in
                let result = lhs.name.localizedStandardCompare(rhs.name)
                return order == .ascending
                    ? result == .orderedAscending
                    : result == .orderedDescending
            }
            output?.didLoadProduce(sorted)
        }
    }
}
