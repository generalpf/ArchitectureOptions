//
//  VIPERProduceListRouter.swift
//  ArchitectureOptions
//

import SwiftUI

extension VIPER {
    /// Assembles the module and owns navigation out of it.
    /// This feature has no outbound navigation yet, so the router only builds the module.
    final class ProduceListRouter {
        static func createModule(dataSource: ProduceDataSource = StaticProduceDataSource()) -> some View {
            let router = ProduceListRouter()
            let interactor = ProduceListInteractor(dataSource: dataSource)
            let presenter = ProduceListPresenter(interactor: interactor, router: router)
            interactor.output = presenter
            return ProduceListView(presenter: presenter)
        }
    }
}
