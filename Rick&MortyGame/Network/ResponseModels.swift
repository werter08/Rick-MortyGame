//
//  LoginResponse.swift
//  TukTuk
//
//  Created by Begench Yangibayev on 13.02.2026.
//

import Foundation
import SwiftUI

class CharachterModel: Codable {
    let id: Int
    let name: String
    let image: String
    let status: CStatus.RawValue
    let species: CSpecies.RawValue
    let gender: CGender.RawValue
    var getFrom: String?
}

class EpisodeModel: Codable {
    let episode: String
    let characters: [String]
}

class LocationModel: Codable {
    let name: String
    let dimension: String
    let residents: [String]
}

/// The Rick and Morty API returns a **JSON array** for `/character/1,2,3` and a **single JSON object** for `/character/1`.
struct CharacterListAPIEnvelope: Decodable {
    let characters: [CharachterModel]

    init(from decoder: Decoder) throws {
        if var unkeyed = try? decoder.unkeyedContainer() {
            var list: [CharachterModel] = []
            while !unkeyed.isAtEnd {
                list.append(try unkeyed.decode(CharachterModel.self))
            }
            characters = list
        } else {
            characters = [try CharachterModel(from: decoder)]
        }
    }
}

enum CStatus: String, CaseIterable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
    
    var color: Color {
        switch self {
        case .alive:
            return Color.green
        case .dead:
            return Color.red
        case .unknown:
            return Color.gray
        }
    }
}

enum CSpecies: String {
    case human = "Human"
}

enum CGender: String {
    case male = "Male"
    case female = "Female"
    case unknown = "unknown"
}
