//
//  VIPERStaticProduceDataSource.swift
//  ArchitectureOptions
//

extension VIPER {
    struct StaticProduceDataSource: ProduceDataSource {
        func allProduce() -> [Produce] {
            [
                Produce(name: "Banana", kind: .fruit, emoji: "🍌"),
                Produce(name: "Carrot", kind: .vegetable, emoji: "🥕"),
                Produce(name: "Apple", kind: .fruit, emoji: "🍎"),
                Produce(name: "Broccoli", kind: .vegetable, emoji: "🥦"),
                Produce(name: "Mango", kind: .fruit, emoji: "🥭"),
                Produce(name: "Eggplant", kind: .vegetable, emoji: "🍆"),
                Produce(name: "Strawberry", kind: .fruit, emoji: "🍓"),
                Produce(name: "Potato", kind: .vegetable, emoji: "🥔"),
                Produce(name: "Grapes", kind: .fruit, emoji: "🍇"),
                Produce(name: "Corn", kind: .vegetable, emoji: "🌽"),
                Produce(name: "Pineapple", kind: .fruit, emoji: "🍍"),
                Produce(name: "Cucumber", kind: .vegetable, emoji: "🥒"),
                Produce(name: "Kiwi", kind: .fruit, emoji: "🥝"),
                Produce(name: "Onion", kind: .vegetable, emoji: "🧅"),
                Produce(name: "Watermelon", kind: .fruit, emoji: "🍉"),
                Produce(name: "Garlic", kind: .vegetable, emoji: "🧄"),
                Produce(name: "Peach", kind: .fruit, emoji: "🍑"),
                Produce(name: "Bell Pepper", kind: .vegetable, emoji: "🫑"),
                Produce(name: "Cherries", kind: .fruit, emoji: "🍒"),
                Produce(name: "Lettuce", kind: .vegetable, emoji: "🥬"),
            ]
        }
    }
}
