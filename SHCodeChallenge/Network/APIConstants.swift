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
    
    // MARK: - Helper function
    private static func getApiToken() -> String {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "APIKey") as? String else {
            fatalError("APIKey value is missing in Info.plist")
        }
        return apiKey
    }
}

// MARK: - API Endpoint Definition
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
                URLQueryItem(name: APIConstants.Params.limit, value: String(APIConstants.perPage)),
                URLQueryItem(name: APIConstants.Params.page, value: String(page))
            ]
        case .searchBreeds(let searchTerm):
            return [
                URLQueryItem(name: APIConstants.Params.search, value: searchTerm)
            ]
        }
    }
    
    func url() -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = APIConstants.scheme
        urlComponents.host = APIConstants.host
        urlComponents.path = APIConstants.version + self.path
        urlComponents.queryItems = self.queryItems
        return urlComponents.url
    }
}
