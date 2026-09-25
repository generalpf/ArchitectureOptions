//
//  TCAProduce.swift
//  ArchitectureOptions
//

import Foundation

extension TCA {
    struct Produce: Identifiable, Equatable, Sendable {
        enum Kind: String, Sendable {
            case fruit = "Fruit"
            case vegetable = "Vegetable"
        }

        let id: UUID
        let name: String
        let kind: Kind
        let emoji: String

        init(id: UUID = UUID(), name: String, kind: Kind, emoji: String) {
            self.id = id
            self.name = name
            self.kind = kind
            self.emoji = emoji
        }
    }
}
