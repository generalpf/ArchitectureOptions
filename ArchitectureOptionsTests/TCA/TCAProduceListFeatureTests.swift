//
//  TCAProduceListFeatureTests.swift
//  ArchitectureOptionsTests
//

import ComposableArchitecture
import Foundation
import Testing
@testable import ArchitectureOptions

@MainActor
struct TCAProduceListFeatureTests {
    private let banana = TCA.Produce(id: UUID(0), name: "banana", kind: .fruit, emoji: "🍌")
    private let carrot = TCA.Produce(id: UUID(1), name: "Carrot", kind: .vegetable, emoji: "🥕")
    private let apple = TCA.Produce(id: UUID(2), name: "Apple", kind: .fruit, emoji: "🍎")

    @Test func loadsProduceSortedAscending() async {
        let stub = [banana, carrot, apple]
        let store = TestStore(initialState: TCA.ProduceListFeature.State()) {
            TCA.ProduceListFeature()
        } withDependencies: {
            $0.produceClient.fetchAll = { stub }
        }

        await store.send(.task)
        await store.receive(\.produceLoaded) {
            $0.produce = [self.apple, self.banana, self.carrot]
        }
    }

    @Test func sortButtonTogglesOrder() async {
        let store = TestStore(
            initialState: TCA.ProduceListFeature.State(produce: [apple, banana, carrot])
        ) {
            TCA.ProduceListFeature()
        }

        await store.send(.sortButtonTapped) {
            $0.sortOrder = .descending
            $0.produce = [self.carrot, self.banana, self.apple]
        }

        await store.send(.sortButtonTapped) {
            $0.sortOrder = .ascending
            $0.produce = [self.apple, self.banana, self.carrot]
        }
    }
}
