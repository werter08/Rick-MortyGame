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
    @AppStorage("unlockedPackRecords") var unlockedPackRecords: [UnlockedPackRecord] = []

    var characterCount: Int {
        availableCharacters.count
    }
    var LocaionCount: Int {
        availableLocations.count
    }
    var EpisodeCount: Int {
        availableEpisodes.count
    }

    /// Episodes the player has access to, sorted by API id (titles from API when known).
    var episodeCollectionItems: [UnlockedPackRecord] {
        mergedItems(kind: .episode, ids: availableEpisodes, placeholder: { "Episode #\($0)" })
    }

    /// Locations the player has access to, sorted by API id.
    var locationCollectionItems: [UnlockedPackRecord] {
        mergedItems(kind: .location, ids: availableLocations, placeholder: { "Location #\($0)" })
    }

    func recordUnlockedEpisode(id: Int, title: String) {
        guard !unlockedPackRecords.contains(where: { $0.kind == .episode && $0.apiId == id }) else { return }
        unlockedPackRecords = unlockedPackRecords + [
            UnlockedPackRecord(kind: .episode, apiId: id, title: title)
        ]
        objectWillChange.send()
    }

    func recordUnlockedLocation(id: Int, title: String) {
        guard !unlockedPackRecords.contains(where: { $0.kind == .location && $0.apiId == id }) else { return }
        unlockedPackRecords = unlockedPackRecords + [
            UnlockedPackRecord(kind: .location, apiId: id, title: title)
        ]
        objectWillChange.send()
    }

    private func mergedItems(
        kind: UnlockedPackRecord.Kind,
        ids: Set<Int>,
        placeholder: (Int) -> String
    ) -> [UnlockedPackRecord] {
        let titled = unlockedPackRecords.filter { $0.kind == kind }
        let knownIds = Set(titled.map(\.apiId))
        let missingIds = ids.subtracting(knownIds).sorted()
        let extras = missingIds.map { UnlockedPackRecord(kind: kind, apiId: $0, title: placeholder($0)) }
        return (titled + extras).sorted { $0.apiId < $1.apiId }
    }

    static let share = AppConfiguration()
    static let maxCharacterCount = 825
    static let maxEpisodeCount = 51
    static let maxLocationCount = 126
}
