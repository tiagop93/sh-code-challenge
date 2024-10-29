//
//  CatDashboardViewModel.swift
//  SHCodeChallenge
//
//  Created by Tiago Pereira on 29/10/2024.
//

import Foundation
import Combine

@Observable
class CatDashboardViewModel {
    @ObservationIgnored var cancellables: Set<AnyCancellable> = []
    var searchString: String = ""
    var cats: [CatBreed] = []
    
    init() {
        populateCats()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    ()
                case .failure(_):
                    ()
                }
            } receiveValue: { response in
                self.cats = response
            }
            .store(in: &cancellables)
    }
    
    private func populateCats() -> AnyPublisher<[CatBreed], Error> {
        if let url = Bundle.main.url(forResource: "catlist", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedCatsResponse = try decoder.decode([CatBreed].self, from: data)
                return Just(decodedCatsResponse)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            } catch {
                print("Error decoding mock JSON data: \(error)")
            }
        } else {
            print("No mock JSON file found")
        }
        return Just([])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
