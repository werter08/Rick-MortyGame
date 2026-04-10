//
//  Set+Extension.swift
//  Rick&MortyGame
//
//  Created by Begench Yangibayev on 10.04.2026.
//

import Foundation

// Generic extension for any Codable element
extension Array: @retroactive RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data) else {
            return nil
        }
        self = result
    }
    
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let string = String(data: data, encoding: .utf8) else {
            return "[]"
        }
        return string
    }
}
