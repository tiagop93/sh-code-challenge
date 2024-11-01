//
//  HTTPClient.swift
//  SHCodeChallenge
//
//  Created by Tiago Pereira on 30/10/2024.
//

import Foundation
import Combine

protocol HTTPClient {
    func fetchCatBreeds(page: Int) -> AnyPublisher<[CatBreedResponse], HTTPClientError>
    
    func searchCatBreeds(searchTerm: String) -> AnyPublisher<[CatBreedResponse], HTTPClientError>
}

// MARK: - HTTPClientError

enum HTTPClientError: Error {
    case badUrl
    case invalidResponse
    case decodingError
    case noInternetConnection
    case networkError(Error)
}
