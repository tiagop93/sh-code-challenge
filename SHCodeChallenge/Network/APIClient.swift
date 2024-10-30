//
//  APIClient.swift
//  SHCodeChallenge
//
//  Created by Tiago Pereira on 30/10/2024.
//

import Foundation
import Combine

struct APIClient: HTTPClient {
    
    // MARK: - Public Methods
    
    func fetchCatBreeds(page: Int) -> AnyPublisher<[CatBreed], HTTPClientError> {
        return request(endpoint: .breeds(page: page))
    }
    
    func searchCatBreeds(searchTerm: String) -> AnyPublisher<[CatBreed], HTTPClientError> {
        return request(endpoint: .searchBreeds(searchTerm: searchTerm))
    }
    
    // MARK: - Private Methods
    
    private func request<T: Decodable>(endpoint: Endpoint) -> AnyPublisher<T, HTTPClientError> {
        guard let url = endpoint.url() else {
            return Fail(error: HTTPClientError.badUrl).eraseToAnyPublisher()
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
    
    private func handleError(_ error: Error) -> HTTPClientError {
        if error is DecodingError {
            return .decodingError
        }
        return .networkError(error)
    }
}
