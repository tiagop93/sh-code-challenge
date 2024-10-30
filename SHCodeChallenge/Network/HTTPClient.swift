//
//  HTTPClient.swift
//  SHCodeChallenge
//
//  Created by Tiago Pereira on 30/10/2024.
//

import Foundation
import Combine

protocol HTTPClient {
    func fetchCatBreeds(page: Int) -> AnyPublisher<[CatBreed], Error>
}

// MARK: HTTPClientError

enum HTTPClientError: Error, Equatable {
    case invalidResponse
    case badUrl
}
