//
//  VIPERProduceListPresenter.swift
//  ArchitectureOptions
//

import Foundation
import Observation

extension VIPER {
    /// Display-ready data for a single row. The View never sees `Produce` entities.
    struct ProduceRowViewModel: Identifiable, Equatable {
        let id: UUID
        let title: String
        let subtitle: String
        let emoji: String
    }

    @Observable
    final class ProduceListPresenter: ProduceListPresenterInput, ProduceListInteractorOutput {
        private(set) var rows: [ProduceRowViewModel] = []
        private(set) var sortOrder: SortOrder = .ascending

        var title: String { "Produce (VIPER)" }

        var sortButtonTitle: String {
            sortOrder == .ascending ? "A → Z" : "Z → A"
        }

        var sortButtonSystemImage: String {
            sortOrder == .ascending ? "arrow.up" : "arrow.down"
        }

        @ObservationIgnored private let interactor: ProduceListInteractorInput
        @ObservationIgnored private let router: ProduceListRouter

        init(interactor: ProduceListInteractorInput, router: ProduceListRouter) {
            self.interactor = interactor
            self.router = router
        }

        // MARK: ProduceListPresenterInput

        func viewDidLoad() {
            interactor.loadProduce(sortedBy: sortOrder)
        }

        func didTapSort() {
            sortOrder = sortOrder.toggled
            interactor.loadProduce(sortedBy: sortOrder)
        }

        // MARK: ProduceListInteractorOutput

        func didLoadProduce(_ produce: [Produce]) {
            rows = produce.map {
                ProduceRowViewModel(id: $0.id, title: $0.name, subtitle: $0.kind.rawValue, emoji: $0.emoji)
            }
        }
    }
}
