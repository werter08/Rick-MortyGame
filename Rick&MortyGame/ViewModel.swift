//
//  ChatRepo.swift
//  Academy
//
//  Created by Begench on 20.10.2025.
//

import Foundation
import Alamofire
import Combine

final class ViewModel: ObservableObject {
    private var cancallables = Set<AnyCancellable>()
    let config = AppConfiguration.share
    @Published var points = AppConfiguration.share.points
    @Published var isLoading = false
    
    @Published var allFetched = false
    @Published var charsBeforeFetching = 0
    @Published var ChactersInFetch = 0
    @Published var fetchedCardName = ""
    
    @Published var errorMessage = ""
    @Published var character: CharachterModel? = nil
    

    init() {
        if config.characterCount == 0 {
            getEpisode(id: 1)
        } else {
            getRandomChar()
        }
    }
    
    
    
    public func getRandomChar() {
        character = nil
        points = points == -1 ? 0 : points
        character = config.availableCharacters.randomElement()
//        getCharachterBy(id: id)
        
    }
    
    public func selectedStatus(status: CStatus, completion: @escaping (Bool) -> Void) {
        if status.rawValue == character?.status ?? "unknown" {
            points=points+1
            completion(true)
        } else {
            points=points-1 >= 0 ? points-1 : 0
            completion(false)
        }
        getRandomChar()
    }

    
    private func getCharachterBy(id: [Int], episode: String?, location: String?) {
        guard !isLoading else { return }
        
        isLoading = true
        ViewModel.getCharacterFromNetwork(id: id)
            .sink { result in
                switch result {
                case .failure(let error): self.errorMessage = error.localizedDescription
                case .finished: self.isLoading = false
                }
            } receiveValue: { models in
                self.isLoading = false
                models.forEach {$0.getFrom = episode ?? location}
                self.config.availableCharacters.append(contentsOf: models)
                self.getRandomChar()
                self.allFetched = true
            }
            .store(in: &cancallables)
    }
    
    private func getEpisode(id: Int) {
        guard !isLoading else { return }
        allFetched = false
        isLoading = true
        ViewModel.getEpisodeFromNetwork(id: id)
            .sink { result in
                switch result {
                case .failure(let error): self.errorMessage = error.localizedDescription
                case .finished: self.isLoading = false
                }
            } receiveValue: { [self] model in
                self.isLoading = false
                self.config.recordUnlockedEpisode(id: id, title: model.episode.displayEpisode)
                let ids: [Int] = model.characters.compactMap { $0.getId }
                self.ChactersInFetch = ids.count
                self.getCharachterBy(id: ids, episode: model.episode, location: nil)
                self.fetchedCardName = model.episode.displayEpisode
            }
            .store(in: &cancallables)
    }

    private func getLocation(id: Int) {
        guard !isLoading else { return }
        allFetched = false
        isLoading = true
        ViewModel.getLocationFromNetwork(id: id)
            .sink { result in
                switch result {
                case .failure(let error): self.errorMessage = error.localizedDescription
                case .finished: self.isLoading = false
                }
            } receiveValue: { [self] model in
                self.isLoading = false
                let ids: [Int] = model.residents.compactMap { $0.getId }
                self.ChactersInFetch = ids.count

                let title: String
                if model.dimension != "unknown" {
                    title = model.dimension + " · " + model.name
                    self.getCharachterBy(id: ids, episode: nil, location: model.dimension + " " + model.name)
                    self.fetchedCardName = model.dimension + " " + model.name
                } else {
                    title = model.name
                    self.getCharachterBy(id: ids, episode: nil, location: model.name)
                    self.fetchedCardName = model.name
                }
                self.config.recordUnlockedLocation(id: id, title: title)
            }
            .store(in: &cancallables)
    }
    
    func buyRandomLocation() {
        if let id = config.closedLocations.randomElement() {
            allFetched = false
            charsBeforeFetching = config.characterCount
            
            config.closedLocations.remove(id)
            config.availableLocations.insert(id)
            
            getLocation(id: id)
            config.locationCost += 2
            points -= 2
            config.objectWillChange.send()
        }
    }

    func buyRandomEpisode() {
        if let id = config.closedEpisodes.randomElement() {
            allFetched = false
            charsBeforeFetching = config.characterCount
            
            config.closedEpisodes.remove(id)
            config.availableEpisodes.insert(id)

            getEpisode(id: id)
            config.episodeCost += 4
            points -= 4
            config.objectWillChange.send()
        }
    }
}

extension ViewModel {
    
    static func getCharacterFromNetwork(id: [Int]) -> AnyPublisher<[CharachterModel], APIError> {
        Network.perform(endpoint: Endpoints.getCharackter(id: id))
            .map { (envelope: CharacterListAPIEnvelope) in envelope.characters }
            .eraseToAnyPublisher()
    }
    static func getEpisodeFromNetwork(id: Int) -> AnyPublisher<EpisodeModel, APIError> {
        Network.perform(endpoint: Endpoints.getEpisode(id: id))
    }
    
    static func getLocationFromNetwork(id: Int) -> AnyPublisher<LocationModel, APIError> {
        Network.perform(endpoint: Endpoints.getLocation(id: id))
    }
}
