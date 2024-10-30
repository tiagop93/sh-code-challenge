//
//  APIClient.swift
//  SHCodeChallenge
//
//  Created by Tiago Pereira on 30/10/2024.
//

import Foundation
import Combine

struct APIClient: HTTPClient {
    
    func fetchCatBreeds(page: Int) -> AnyPublisher<[CatBreed], any Error> {
        
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
            .catch { error in
                return Fail(error: error)
            }
            .eraseToAnyPublisher()
    }
    
}
