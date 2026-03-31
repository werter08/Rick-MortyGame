//
//  LoginResponse.swift
//  TukTuk
//
//  Created by Begench Yangibayev on 13.02.2026.
//

import Foundation
import SwiftUI

class CharachterModel: Codable {
    let name: String
    let image: String
    let status: CStatus.RawValue
    let species: CSpecies.RawValue
    let gender: CGender.RawValue
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
