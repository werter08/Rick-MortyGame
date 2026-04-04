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

    @Published var isLoading = false
    @Published var points = -1
    @Published var errorMessage = ""
    @Published var character: CharachterModel? = nil
    @Published var nextCharacter: CharachterModel? = nil

    

    init() {
        let id = Int.random(in: ViewModel.minId...ViewModel.maxId)
        ViewModel.getCharacterFromNetwork(id: id)
            .sink { result in
                switch result {
                case .failure(let error): self.errorMessage = error.localizedDescription
                case .finished: self.isLoading = false
                }
            } receiveValue: { model in
                self.isLoading = false
                self.nextCharacter = model
            }
            .store(in: &cancallables)
    }
    
    
    
    public func getRandomChar() {
        let id = Int.random(in: ViewModel.minId...ViewModel.maxId)
        character = nil
        points = points == -1 ? 0 : points
        getCharachterBy(id: id)
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

    
    private func getCharachterBy(id: Int) {
        guard !isLoading else { return }
        
        isLoading = true
        character = nextCharacter
        ViewModel.getCharacterFromNetwork(id: id)
            .sink { result in
                switch result {
                case .failure(let error): self.errorMessage = error.localizedDescription
                case .finished: self.isLoading = false
                }
            } receiveValue: { model in
                self.isLoading = false
                
                self.nextCharacter  = model
                
            }
            .store(in: &cancallables)
    }
}

extension ViewModel {
    static let minId = 1
    static let maxId = 825
    
    static func getCharacterFromNetwork(id: Int) -> AnyPublisher<CharachterModel, APIError> {
        Network.perform(endpoint: Endpoints.getCharackter(id: id))
    }
}
