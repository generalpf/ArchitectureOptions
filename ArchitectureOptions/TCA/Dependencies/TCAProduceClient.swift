//
//  TCAProduceClient.swift
//  ArchitectureOptions
//

import ComposableArchitecture

extension TCA {
    @DependencyClient
    struct ProduceClient: Sendable {
        var fetchAll: @Sendable () async -> [Produce] = { [] }
    }
}

extension TCA.ProduceClient: DependencyKey {
    static let liveValue = TCA.ProduceClient(
        fetchAll: {
            [
                .init(name: "Banana", kind: .fruit, emoji: "🍌"),
                .init(name: "Carrot", kind: .vegetable, emoji: "🥕"),
                .init(name: "Apple", kind: .fruit, emoji: "🍎"),
                .init(name: "Broccoli", kind: .vegetable, emoji: "🥦"),
                .init(name: "Mango", kind: .fruit, emoji: "🥭"),
                .init(name: "Eggplant", kind: .vegetable, emoji: "🍆"),
                .init(name: "Strawberry", kind: .fruit, emoji: "🍓"),
                .init(name: "Potato", kind: .vegetable, emoji: "🥔"),
                .init(name: "Grapes", kind: .fruit, emoji: "🍇"),
                .init(name: "Corn", kind: .vegetable, emoji: "🌽"),
                .init(name: "Pineapple", kind: .fruit, emoji: "🍍"),
                .init(name: "Cucumber", kind: .vegetable, emoji: "🥒"),
                .init(name: "Kiwi", kind: .fruit, emoji: "🥝"),
                .init(name: "Onion", kind: .vegetable, emoji: "🧅"),
                .init(name: "Watermelon", kind: .fruit, emoji: "🍉"),
                .init(name: "Garlic", kind: .vegetable, emoji: "🧄"),
                .init(name: "Peach", kind: .fruit, emoji: "🍑"),
                .init(name: "Bell Pepper", kind: .vegetable, emoji: "🫑"),
                .init(name: "Cherries", kind: .fruit, emoji: "🍒"),
                .init(name: "Lettuce", kind: .vegetable, emoji: "🥬"),
            ]
        }
    )

    static let testValue = TCA.ProduceClient()
}

extension DependencyValues {
    var produceClient: TCA.ProduceClient {
        get { self[TCA.ProduceClient.self] }
        set { self[TCA.ProduceClient.self] = newValue }
    }
}
