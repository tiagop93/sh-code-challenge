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
    static let apiHeaderKey = "x-api-key"
    static let apiKey = getApiToken()
    static var imageBaseURL: String {
        return "\(scheme)://\(cdnHost)/images/"
    }
    
    // MARK: API Endpoints
    
    enum Endpoint {
        case breeds(page: Int)
        
        var path: String {
            switch self {
            case .breeds:
                return "/breeds"
            }
        }
        
        var queryItems: [URLQueryItem]? {
            switch self {
            case .breeds(let page):
                return [
                    URLQueryItem(name: "limit", value: String(perPage)),
                    URLQueryItem(name: "page", value: String(page))
                ]
            }
        }
    }
    
    // MARK: Helper methods
    
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
