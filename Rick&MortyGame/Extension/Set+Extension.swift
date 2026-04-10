//
//  Set+Extension.swift
//  Rick&MortyGame
//
//  Created by Begench Yangibayev on 10.04.2026.
//

import Foundation

extension Set: RawRepresentable where Element == Int {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let array = try? JSONDecoder().decode([Int].self, from: data) else {
            return nil
        }
        self = Set(array)
    }
    
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(Array(self)),
              let string = String(data: data, encoding: .utf8) else {
            return "[]"
        }
        return string
    }
}
