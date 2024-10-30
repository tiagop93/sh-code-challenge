//
//  MockAPIClient.swift
//  SHCodeChallenge
//
//  Created by Tiago Pereira on 30/10/2024.
//

import Foundation
import Combine

struct MockAPIClient: HTTPClient {
    func fetchCatBreeds(page: Int) -> AnyPublisher<[CatBreed], HTTPClientError> {
        if let url = Bundle.main.url(forResource: "catlist", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedResponse = try decoder.decode([CatBreed].self, from: data)
                return Just(decodedResponse)
                    .setFailureType(to: HTTPClientError.self)
                    .eraseToAnyPublisher()
            } catch {
                print("Error decoding mock JSON data: \(error)")
            }
        } else {
            print("No mock JSON file found")
        }
        return Just([])
            .setFailureType(to: HTTPClientError.self)
            .eraseToAnyPublisher()
    }
    
    func searchCatBreeds(searchTerm: String) -> AnyPublisher<[CatBreed], HTTPClientError> {
        fetchCatBreeds(page: 0)
    }
    
    func getFirstCatBreed() -> CatBreed? {
        if let url = Bundle.main.url(forResource: "catlist", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedResponse = try decoder.decode([CatBreed].self, from: data)
                return decodedResponse.first
            } catch {
                print("Error decoding mock JSON data: \(error)")
                return nil
            }
        } else {
            print("No mock JSON file found")
            return nil
        }
    }
}
