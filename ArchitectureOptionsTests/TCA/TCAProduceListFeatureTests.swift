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

    @Test func loadsProduceAndShowsAllSortedAscending() async {
        let stub = [banana, carrot, apple]
        let store = TestStore(initialState: TCA.ProduceListFeature.State()) {
            TCA.ProduceListFeature()
        } withDependencies: {
            $0.produceClient.fetchAll = { stub }
        }

        await store.send(.task)
        await store.receive(\.produceLoaded) {
            $0.produce = [self.banana, self.carrot, self.apple]
        }

        #expect(store.state.filter == .all)
        #expect(store.state.visibleProduce == [apple, banana, carrot])
    }

    @Test func sortButtonTogglesOrder() async {
        let store = TestStore(
            initialState: TCA.ProduceListFeature.State(produce: [apple, banana, carrot])
        ) {
            TCA.ProduceListFeature()
        }

        await store.send(.sortButtonTapped) {
            $0.sortOrder = .descending
        }
        #expect(store.state.visibleProduce == [carrot, banana, apple])

        await store.send(.sortButtonTapped) {
            $0.sortOrder = .ascending
        }
        #expect(store.state.visibleProduce == [apple, banana, carrot])
    }

    @Test func filterChangedShowsOnlyMatchingKind() async {
        let store = TestStore(
            initialState: TCA.ProduceListFeature.State(produce: [apple, banana, carrot])
        ) {
            TCA.ProduceListFeature()
        }

        await store.send(.filterChanged(.fruit)) {
            $0.filter = .fruit
        }
        #expect(store.state.visibleProduce == [apple, banana])

        await store.send(.filterChanged(.vegetables)) {
            $0.filter = .vegetables
        }
        #expect(store.state.visibleProduce == [carrot])

        await store.send(.filterChanged(.all)) {
            $0.filter = .all
        }
        #expect(store.state.visibleProduce == [apple, banana, carrot])
    }
}
