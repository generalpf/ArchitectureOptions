//
//  MVPProduceListViewProtocol.swift
//  ArchitectureOptions
//
//  The passive View contract. The Presenter pushes display-ready values into it;
//  the View never pulls from the Presenter or the Model.
//

import Foundation
import Observation

extension MVP {
    struct ProduceRowViewModel: Identifiable, Equatable {
        let id: UUID
        let title: String
        let subtitle: String
        let emoji: String
    }

    protocol ProduceListViewProtocol: AnyObject {
        func display(rows: [ProduceRowViewModel])
        func display(sortButtonTitle: String, systemImage: String)
        func display(selectedFilter: ProduceListPresenter.Filter)
    }

    /// SwiftUI views are structs, so they can't be the Presenter's (weak, reference-type) view.
    /// This adapter is the object the Presenter talks to; the SwiftUI view renders whatever it holds.
    @Observable
    final class ProduceListDisplay: ProduceListViewProtocol {
        private(set) var rows: [ProduceRowViewModel] = []
        private(set) var sortButtonTitle = ""
        private(set) var sortButtonSystemImage = ""
        private(set) var selectedFilter: ProduceListPresenter.Filter = .all

        func display(rows: [ProduceRowViewModel]) {
            self.rows = rows
        }

        func display(sortButtonTitle: String, systemImage: String) {
            self.sortButtonTitle = sortButtonTitle
            self.sortButtonSystemImage = systemImage
        }

        func display(selectedFilter: ProduceListPresenter.Filter) {
            self.selectedFilter = selectedFilter
        }
    }
}
