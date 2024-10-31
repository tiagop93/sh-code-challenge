//
//  DataPersistence.swift
//  SHCodeChallenge
//
//  Created by Tiago Pereira on 31/10/2024.
//

import Foundation

protocol DataPersistence {
    func saveCatBreeds(_ breeds: [CatBreed])
    func fetchAllCatBreeds() -> [CatBreedEntity]
    func toggleFavoriteStatus(for breedID: String)
    func fetchFavorites() -> [CatBreedEntity]
}
