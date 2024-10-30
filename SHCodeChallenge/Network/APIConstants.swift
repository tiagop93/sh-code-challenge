//
//  APIConstants.swift
//  SHCodeChallenge
//
//  Created by Tiago Pereira on 30/10/2024.
//

import Foundation

enum APIConstants {
    static let scheme = "https"
    static let host = "api.thecatapi.com"
    static let cdnHost = "cdn2.thecatapi.com"
    static let version = "/v1"
    static let perPage = 20
    static let initialPage = 0
    static let apiKey = getApiToken()
    
    // MARK: - Base URLs
    static var imageBaseURL: String {
        return "\(scheme)://\(cdnHost)/images/"
    }
    
    // MARK: - API Parameters Keys
    enum Params {
        static let limit = "limit"
        static let page = "page"
        static let search = "q"
    }
    
    // MARK: - API Header Keys
    enum Headers {
        static let apiKey = "x-api-key"
    }
    
    // MARK: - API Endpoints
    
    enum Endpoint {
        case breeds(page: Int)
        case searchBreeds(searchTerm: String)
        
        var path: String {
            switch self {
            case .breeds:
                return "/breeds"
            case .searchBreeds:
                return "/breeds/search"
            }
        }
        
        var queryItems: [URLQueryItem]? {
            switch self {
            case .breeds(let page):
                return [
                    URLQueryItem(name: Params.limit, value: String(perPage)),
                    URLQueryItem(name: Params.page, value: String(page))
                ]
            case .searchBreeds(let searchTerm):
                return [
                    URLQueryItem(name: Params.search, value: searchTerm)
                ]
            }
        }
    }
    
    // MARK: - Helper methods
    
    static func url(for endpoint: Endpoint) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = version + endpoint.path
        urlComponents.queryItems = endpoint.queryItems
        return urlComponents.url
    }
    
    private static func getApiToken() -> String {
        if let apiKey = Bundle.main.object(forInfoDictionaryKey: "APIKey") as? String {
            return apiKey
        } else {
            fatalError("APIKey value is missing")
        }
    }
}
