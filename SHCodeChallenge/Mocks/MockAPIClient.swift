//
//  MockAPIClient.swift
//  SHCodeChallenge
//
//  Created by Tiago Pereira on 30/10/2024.
//

import Foundation
import Combine

struct MockAPIClient: HTTPClient {
    
    // MARK: - Public Methods
    
    func fetchCatBreeds(page: Int) -> AnyPublisher<[CatBreed], HTTPClientError> {
        loadMockData(fileName: "catlist", type: [CatBreed].self)
    }
    
    func searchCatBreeds(searchTerm: String) -> AnyPublisher<[CatBreed], HTTPClientError> {
        loadMockData(fileName: "catlist", type: [CatBreed].self)
    }
    
    func getFirstCatBreed() -> CatBreed? {
        try? loadMockDataSync(fileName: "catlist", type: [CatBreed].self).first
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
