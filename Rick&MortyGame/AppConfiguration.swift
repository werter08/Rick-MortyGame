//
//  AppConfiguration.swift
//  BeletVideo
//
//  Created by atakishiyev on 2/17/24.
//

import SwiftUI
import Combine

final class AppConfiguration: ObservableObject {

    @AppStorage("closedEpisodes") var closedEpisodes: Set<Int> = Set(2...51)
    @AppStorage("closedLocations") var closedLocations: Set<Int> = Set(1...126)
    @AppStorage("availableEpisodes") var availableEpisodes: Set<Int> = Set(1...1)
    @AppStorage("availableLocations") var availableLocations: Set<Int> = Set()
    @AppStorage("availablecharacters") var availableCharacters: [CharachterModel] = []
    @AppStorage("points") var points: Int = 0
    @AppStorage("locationCost") var locationCost: Int = 4
    @AppStorage("episodeCost") var episodeCost: Int = 8
    
    var characterCount: Int {
        availableCharacters.count 
    }
    var LocaionCount: Int {
        availableLocations.count
    }
    var EpisodeCount: Int {
        availableEpisodes.count
    }
    
    static let share = AppConfiguration()
    static let maxCharacterCount = 825
    static let maxEpisodeCount = 51
    static let maxLocationCount = 126
}
