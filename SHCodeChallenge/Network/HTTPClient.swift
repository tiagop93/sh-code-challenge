//
//  HTTPClient.swift
//  SHCodeChallenge
//
//  Created by Tiago Pereira on 30/10/2024.
//

import Foundation
import Combine

protocol HTTPClient {
    func fetchCatBreeds(page: Int) -> AnyPublisher<DataResponse<[CatBreedResponse]>, HTTPClientError>
    
    func searchCatBreeds(searchTerm: String) -> AnyPublisher<DataResponse<[CatBreedResponse]>, HTTPClientError>
    
}

// MARK: - DataSource

enum HTTPDataSource {
    case online
    case offline
}

// MARK: - DataResponse

struct DataResponse<T> {
    let data: T
    let source: HTTPDataSource
}

// MARK: - HTTPClientError

enum HTTPClientError: Error {
    case badUrl
    case invalidResponse
    case decodingError
    case noInternetConnection
    case networkError(Error)
}
