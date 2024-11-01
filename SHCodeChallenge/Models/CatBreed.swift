//
//  CatBreed.swift
//  SHCodeChallenge
//
//  Created by Tiago Pereira on 01/11/2024.
//

import Foundation

struct CatBreed: Identifiable {
    let id: String
    let name: String
    let origin: String
    let description: String
    let temperament: String
    let lifeSpan: String
    var imageUrl: URL?
    var isFavorite: Bool
    
    init(catBreedResponse: CatBreedResponse, isFavorite: Bool) {
        self.id = catBreedResponse.id
        self.name = catBreedResponse.name
        self.origin = catBreedResponse.origin
        self.description = catBreedResponse.description
        self.temperament = catBreedResponse.temperament
        self.lifeSpan = catBreedResponse.lifeSpan
        self.imageUrl = catBreedResponse.imageUrl
        self.isFavorite = isFavorite
    }
    
    init(catBreedEntity: CatBreedEntity) {
        self.id = catBreedEntity.id
        self.name = catBreedEntity.name
        self.origin = catBreedEntity.origin
        self.description = catBreedEntity.breedDescription
        self.temperament = catBreedEntity.temperament
        self.lifeSpan = catBreedEntity.lifeSpan
        self.imageUrl = URL(string: catBreedEntity.imageUrl ?? "")
        self.isFavorite = catBreedEntity.isFavorite
    }
}
