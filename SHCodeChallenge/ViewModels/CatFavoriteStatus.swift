//
//  CatFavoriteStatus.swift
//  SHCodeChallenge
//
//  Created by Tiago Pereira on 30/10/2024.
//

import Foundation
import Combine
import SwiftUI

@Observable
class CatFavoriteStatus {
    @ObservationIgnored private let dataStore: CatBreedDataPersistence  // Consistent type usage
    private var favoriteBreeds: Set<String> = []

    init(dataStore: CatBreedDataPersistence) {
        self.dataStore = dataStore
        loadFavorites()
    }

    private func loadFavorites() {
        let favorites = dataStore.fetchFavorites()
        self.favoriteBreeds = Set(favorites.map { $0.id })
    }

    func isFavorite(breedID: String) -> Bool {
        favoriteBreeds.contains(breedID)
    }

    func toggleFavorite(breedID: String) {
        if favoriteBreeds.contains(breedID) {
            favoriteBreeds.remove(breedID)
        } else {
            favoriteBreeds.insert(breedID)
        }
        dataStore.toggleFavoriteStatus(for: breedID)
    }
    
    func getFavoriteBreeds() -> [CatBreed] {
        return dataStore.fetchFavorites()
            .filter { favoriteBreeds.contains($0.id) } // Only include those in favoriteBreeds set
            .map { entity in
                CatBreed(
                    id: entity.id,
                    name: entity.name,
                    origin: entity.origin,
                    description: entity.breedDescription,
                    temperament: entity.temperament,
                    lifeSpan: entity.lifeSpan,
                    referenceImageId: entity.referenceImageId
                )
            }
    }

    func isFavoriteBinding(for breedID: String) -> Binding<Bool> {
        Binding(
            get: { self.isFavorite(breedID: breedID) },
            set: { newValue in
                if newValue {
                    self.favoriteBreeds.insert(breedID)
                } else {
                    self.favoriteBreeds.remove(breedID)
                }
                self.toggleFavorite(breedID: breedID)
            }
        )
    }
}
