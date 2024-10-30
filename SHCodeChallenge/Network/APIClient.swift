//
//  APIClient.swift
//  SHCodeChallenge
//
//  Created by Tiago Pereira on 30/10/2024.
//

import Foundation
import Combine

struct APIClient: HTTPClient {
    
    func fetchCatBreeds(page: Int) -> AnyPublisher<[CatBreed], HTTPClientError> {
        
        guard let url = APIConstants.url(for: .breeds(page: page)) else {
            return Fail(error: HTTPClientError.badUrl)
                .eraseToAnyPublisher()
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw HTTPClientError.invalidResponse
                }
                
                return data
            }
            .decode(type: [CatBreed].self, decoder: decoder)
            .mapError{ error -> HTTPClientError in
                if error is DecodingError {
                    return .decodingError
                }
                return .networkError(error)
            }
            .eraseToAnyPublisher()
    }
    
    func searchCatBreeds(searchTerm: String) -> AnyPublisher<[CatBreed], HTTPClientError> {
        
        guard let url = APIConstants.url(for: .searchBreeds(searchTerm: searchTerm)) else {
            return Fail(error: HTTPClientError.badUrl)
                .eraseToAnyPublisher()
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw HTTPClientError.invalidResponse
                }
                
                return data
            }
            .decode(type: [CatBreed].self, decoder: decoder)
            .mapError{ error -> HTTPClientError in
                if error is DecodingError {
                    return .decodingError
                }
                return .networkError(error)
            }
            .eraseToAnyPublisher()
    }
    
}
