//
//  CatBreedEntity.swift
//  SHCodeChallenge
//
//  Created by Tiago Pereira on 31/10/2024.
//

import SwiftData

@Model
class CatBreedEntity {
    @Attribute(.unique) var id: String
    var name: String
    var origin: String
    var breedDescription: String
    var temperament: String
    var lifeSpan: String
    var referenceImageId: String?
    var imageUrl: String?
    var isFavorite: Bool = false
    
    init(catBreed: CatBreed, isFavorite: Bool) {
        id = catBreed.id
        name = catBreed.name
        origin = catBreed.origin
        breedDescription = catBreed.description
        temperament = catBreed.temperament
        lifeSpan = catBreed.lifeSpan
        referenceImageId = catBreed.referenceImageId
        imageUrl = catBreed.imageUrl?.absoluteString
        self.isFavorite = isFavorite
    }
}
