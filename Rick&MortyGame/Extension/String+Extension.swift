//
//  String+Extension.swift
//  Rick&MortyGame
//
//  Created by Begench Yangibayev on 10.04.2026.
//

import Foundation

extension String {
    /// "some/string/12" return 12
    var getId: Int? {
        let components = self.split(separator: "/")
        
        guard let lastPart = components.last else { return nil }
        
        return Int(lastPart)
    }
    
    /// "S01E02" → "Season 1 Episode 2"
    /// "s1e2"   → "Season 1 Episode 2"
    /// "S10E03" → "Season 10 Episode 3"
    var displayEpisode: String {
        // Remove whitespace and make uppercase for easier parsing
        let cleaned = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        // Look for pattern like S01E02 or S1E2
        let pattern = #"S(\d{1,2})E(\d{1,2})"#
        
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: cleaned, range: NSRange(cleaned.startIndex..., in: cleaned)) else {
            return self  // Return original string if pattern doesn't match
        }
        
        let seasonRange = Range(match.range(at: 1), in: cleaned)!
        let episodeRange = Range(match.range(at: 2), in: cleaned)!
        
        let season = Int(cleaned[seasonRange]) ?? 0
        let episode = Int(cleaned[episodeRange]) ?? 0
        
        return "Season \(season) Episode \(episode)"
    }
}
