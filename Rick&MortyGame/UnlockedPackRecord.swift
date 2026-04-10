//
//  UnlockedPackRecord.swift
//  Rick&MortyGame
//

import Foundation

struct UnlockedPackRecord: Codable, Hashable, Identifiable {
    enum Kind: String, Codable {
        case episode
        case location
    }

    let kind: Kind
    let apiId: Int
    var title: String

    var id: String { "\(kind.rawValue)-\(apiId)" }
}
