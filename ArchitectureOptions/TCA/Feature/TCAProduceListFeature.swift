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

        @ObservableState
        struct State: Equatable {
            var produce: IdentifiedArrayOf<Produce> = []
            var sortOrder: SortOrder = .ascending

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
                    state.produce = IdentifiedArray(uniqueElements: Self.sorted(produce, by: state.sortOrder))
                    return .none

                case .sortButtonTapped:
                    state.sortOrder = state.sortOrder.toggled
                    state.produce = IdentifiedArray(uniqueElements: Self.sorted(Array(state.produce), by: state.sortOrder))
                    return .none
                }
            }
        }

        private static func sorted(_ produce: [Produce], by order: SortOrder) -> [Produce] {
            produce.sorted { lhs, rhs in
                let result = lhs.name.localizedStandardCompare(rhs.name)
                return order == .ascending
                    ? result == .orderedAscending
                    : result == .orderedDescending
            }
        }
    }
}
