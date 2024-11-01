//
//  APIClient.swift
//  SHCodeChallenge
//
//  Created by Tiago Pereira on 30/10/2024.
//

import Foundation
import Combine

struct APIClient: HTTPClient {
    // MARK: - Properties
    private let dataPersistence: DataPersistence
    private let reachability: NetworkReachability

    // MARK: - Initialization
    init(persistence: DataPersistence = CatBreedDataPersistence.shared,
         reachability: NetworkReachability = DefaultNetworkReachability()) {
        self.dataPersistence = persistence
        self.reachability = reachability
    }
    
    // MARK: - Public Methods
    
    func fetchCatBreeds(page: Int) -> AnyPublisher<[CatBreedResponse], HTTPClientError> {
        if reachability.isConnected {
            return request(endpoint: .breeds(page: page))
                .handleEvents(receiveOutput: { catBreeds in
                    dataPersistence.saveCatBreeds(catBreeds)
                })
                .eraseToAnyPublisher()
        } else {
            print("No internet connection, using local data")
            let cachedBreeds = dataPersistence.fetchAllCatBreeds()
                .map { CatBreedResponse(id: $0.id, name: $0.name, origin: $0.origin, description: $0.breedDescription, temperament: $0.temperament, lifeSpan: $0.lifeSpan, referenceImageId: $0.referenceImageId) }
            return Just(cachedBreeds)
                .setFailureType(to: HTTPClientError.self)
                .eraseToAnyPublisher()
        }
    }
    
    func searchCatBreeds(searchTerm: String) -> AnyPublisher<[CatBreedResponse], HTTPClientError> {
        guard reachability.isConnected else {
            return Fail(error: HTTPClientError.noInternetConnection)
                .eraseToAnyPublisher()
        }
        return request(endpoint: .searchBreeds(searchTerm: searchTerm))
            .eraseToAnyPublisher()
    }
    
    // MARK: - Private Methods
    
    private func request<T: Decodable>(endpoint: Endpoint) -> AnyPublisher<T, HTTPClientError> {
        guard let url = endpoint.url() else {
            return Fail(error: HTTPClientError.badUrl)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw HTTPClientError.invalidResponse
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder.defaultDecoder)
            .mapError { self.handleError($0) }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Error Handling
    
    private func handleError(_ error: Error) -> HTTPClientError {
        if error is DecodingError {
            return .decodingError
        }
        return .networkError(error)
    }
}
