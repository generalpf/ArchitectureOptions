//
//  TCAProduceListFeature.swift
//  ArchitectureOptions
//

import ComposableArchitecture
import Foundation

extension TCA {
    @Reducer
    struct ProduceListFeature {
        enum SortOrder: Equatable, Sendable {
            case ascending
            case descending

            var toggled: SortOrder {
                self == .ascending ? .descending : .ascending
            }
        }

        enum Filter: CaseIterable, Identifiable, Equatable, Sendable {
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

        @ObservableState
        struct State: Equatable {
            var produce: IdentifiedArrayOf<Produce> = []
            var sortOrder: SortOrder = .ascending
            var filter: Filter = .all

            /// Derived from `produce`, `filter` and `sortOrder` so there's a single source of truth.
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
        }

        enum Action: Sendable {
            case task
            case produceLoaded([Produce])
            case sortButtonTapped
            case filterChanged(Filter)
        }

        @Dependency(\.produceClient) var produceClient

        var body: some Reducer<State, Action> {
            Reduce { state, action in
                switch action {
                case .task:
                    return .run { send in
                        await send(.produceLoaded(await produceClient.fetchAll()))
                    }

                case let .produceLoaded(produce):
                    state.produce = IdentifiedArray(uniqueElements: produce)
                    return .none

                case .sortButtonTapped:
                    state.sortOrder = state.sortOrder.toggled
                    return .none

                case let .filterChanged(filter):
                    state.filter = filter
                    return .none
                }
            }
        }
    }
}
