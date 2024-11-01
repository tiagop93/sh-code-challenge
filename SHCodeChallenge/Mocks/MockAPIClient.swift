//
//  MockAPIClient.swift
//  SHCodeChallenge
//
//  Created by Tiago Pereira on 30/10/2024.
//

import Foundation
import Combine

struct MockAPIClient: HTTPClient {
    
    // MARK: - Properties
    private let dataPersistence: DataPersistence
    
    // MARK: - Initialization
    init(persistence: DataPersistence = CatBreedDataPersistence.mock) {
        self.dataPersistence = persistence
    }
    
    // MARK: - Public Methods
    
    func fetchCatBreeds(page: Int) -> AnyPublisher<[CatBreedResponse], HTTPClientError> {
        return loadMockData(fileName: "catlist", type: [CatBreedResponse].self)
            .handleEvents(receiveOutput: { catBreeds in
                dataPersistence.saveCatBreeds(catBreeds)
            })
            .eraseToAnyPublisher()
    }
    
    func searchCatBreeds(searchTerm: String) -> AnyPublisher<[CatBreedResponse], HTTPClientError> {
        loadMockData(fileName: "catlist", type: [CatBreedResponse].self)
    }
    
    func getFirstCatBreed() -> CatBreedResponse? {
        try? loadMockDataSync(fileName: "catlist", type: [CatBreedResponse].self).first
    }
    
    // MARK: - Private Helper Methods
    
    private func loadMockData<T: Decodable>(fileName: String, type: T.Type) -> AnyPublisher<T, HTTPClientError> {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            return Fail(error: HTTPClientError.badUrl)
                .eraseToAnyPublisher()
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decodedData = try JSONDecoder.defaultDecoder.decode(T.self, from: data)
            return Just(decodedData)
                .setFailureType(to: HTTPClientError.self)
                .eraseToAnyPublisher()
        } catch {
            print("Error decoding mock JSON data: \(error)")
            return Fail(error: .decodingError).eraseToAnyPublisher()
        }
    }
    
    private func loadMockDataSync<T: Decodable>(fileName: String, type: T.Type) throws -> T {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            throw HTTPClientError.badUrl
        }
        
        let data = try Data(contentsOf: url)
        return try JSONDecoder.defaultDecoder.decode(T.self, from: data)
    }
}
