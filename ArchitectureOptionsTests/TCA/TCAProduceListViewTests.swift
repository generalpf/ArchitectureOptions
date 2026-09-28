//
//  TCAProduceListViewTests.swift
//  ArchitectureOptionsTests
//
//  Verifies the View sends the right actions to its Store.
//

import ComposableArchitecture
import SwiftUI
import Testing
import ViewInspector
@testable import ArchitectureOptions

@MainActor
struct TCAProduceListViewTests {
    /// Records every action the View sends, without running the real reducer.
    private final class ActionRecorder {
        var actions: [TCA.ProduceListFeature.Action] = []
    }

    private func makeSUT() -> (TCA.ProduceListView, ActionRecorder) {
        let recorder = ActionRecorder()
        let store = Store(initialState: TCA.ProduceListFeature.State()) {
            Reduce<TCA.ProduceListFeature.State, TCA.ProduceListFeature.Action> { _, action in
                recorder.actions.append(action)
                return .none
            }
        }
        return (TCA.ProduceListView(store: store), recorder)
    }

    @Test func taskSendsTaskAction() async throws {
        let (sut, recorder) = makeSUT()

        try await sut.inspect().find(ViewType.List.self).callTask()

        #expect(recorder.actions == [.task])
    }

    @Test func tappingSortSendsSortButtonTapped() throws {
        let (sut, recorder) = makeSUT()

        try sut.inspect().find(viewWithAccessibilityIdentifier: "sortButton").button().tap()

        #expect(recorder.actions == [.sortButtonTapped])
    }

    @Test func selectingFilterSendsFilterChanged() throws {
        let (sut, recorder) = makeSUT()

        try sut.inspect().find(viewWithAccessibilityIdentifier: "filterPicker").picker()
            .select(value: TCA.ProduceListFeature.Filter.vegetables)

        #expect(recorder.actions == [.filterChanged(.vegetables)])
    }
}
