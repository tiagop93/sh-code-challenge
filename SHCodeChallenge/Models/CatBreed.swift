//
//  Cat.swift
//  SHCodeChallenge
//
//  Created by Tiago Pereira on 29/10/2024.
//

import Foundation

struct CatBreed: Decodable, Identifiable {
    let id: String
    let name: String
    let origin: String
    let description: String
    let temperament: String
    let lifeSpan: String
    let referenceImageId: String?
    
    // MARK: Custom properties
    
    var imageUrl: URL? {
        guard let imageId = referenceImageId else { return nil }
        return URL(string: APIConstants.imageBaseURL + imageId + ".jpg")
    }
}
