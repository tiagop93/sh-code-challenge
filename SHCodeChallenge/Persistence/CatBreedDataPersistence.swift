//
//  CatBreedDataPersistence.swift
//  SHCodeChallenge
//
//  Created by Tiago Pereira on 31/10/2024.
//

import Foundation
import SwiftData

class CatBreedDataPersistence: DataPersistence {
    
    // MARK: - Properties
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    // MARK: - Singleton Instance for Production Database
    @MainActor
    static let shared: CatBreedDataPersistence = {
        return CatBreedDataPersistence(isInMemory: false)
    }()
    
    // MARK: - Singleton for Mock Database
    @MainActor
    static let mock: CatBreedDataPersistence = {
        return CatBreedDataPersistence(isInMemory: true)
    }()
    
    // MARK: - Initialization
    @MainActor
    private init(isInMemory: Bool = false) {
        do {
            self.modelContainer = try ModelContainer(for: CatBreedEntity.self, configurations: ModelConfiguration(isStoredInMemoryOnly: isInMemory))
            self.modelContext = modelContainer.mainContext
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error.localizedDescription)")
        }
    }
}

// MARK: - Core Data Persistence Methods
extension CatBreedDataPersistence {
    
    func saveCatBreeds(_ breeds: [CatBreedResponse]) {
        do {
            for breed in breeds {
                if !ifExists(for: breed.id) {
                    let entity = CatBreedEntity(catBreed: breed, isFavorite: false)
                    modelContext.insert(entity)
                }
            }
            try modelContext.save()
        } catch {
            print("Error saving cat breeds: \(error.localizedDescription)")
        }
    }
    
    func fetchAllCatBreeds() -> [CatBreedEntity] {
        do {
            return try modelContext.fetch(FetchDescriptor<CatBreedEntity>())
        } catch {
            print("Error fetching all cat breeds: \(error.localizedDescription)")
            return []
        }
    }  
    
    func fetchCatBreeds(for breeds: [CatBreedResponse]) -> [CatBreedEntity] {
        do {
            let breedsIDs = breeds.map { $0.id }
            return try modelContext.fetch(FetchDescriptor<CatBreedEntity>(predicate: #Predicate { catBreed in
                breedsIDs.contains(catBreed.id)
            }))
        } catch {
            print("Error fetching cat breeds: \(error.localizedDescription)")
            return []
        }
    }
    
    func toggleFavoriteStatus(for breedID: String) {
        do {
            if let breed = try fetchEntity(for: breedID) {
                breed.isFavorite.toggle()
                try modelContext.save()
            }
        } catch {
            print("Error toggling favorite status: \(error.localizedDescription)")
        }
    }
    
    
    func fetchFavorites() -> [CatBreedEntity] {
        do {
            let request = FetchDescriptor<CatBreedEntity>(predicate: #Predicate { $0.isFavorite == true })
            return try modelContext.fetch(request)
        } catch {
            print("Error fetching favorite breeds: \(error.localizedDescription)")
            return []
        }
    }
    
    func fetchFavoriteStatus(for breedID: String) -> Bool {
        do {
            let request = FetchDescriptor<CatBreedEntity>(predicate: #Predicate { $0.id == breedID })
            return try modelContext.fetch(request).first?.isFavorite ?? false
        } catch {
            print("Error fetching favorite status: \(error.localizedDescription)")
            return false
        }
    }
    
    // MARK: - Helper Methods
    
    private func ifExists(for breedID: String) -> Bool {
        do {
            let request = FetchDescriptor<CatBreedEntity>(predicate: #Predicate { $0.id == breedID })
            return try modelContext.fetch(request).first != nil
        } catch {
            print("Error checking entity existence: \(error.localizedDescription)")
            return false
        }
    }
    
    private func fetchEntity(for breedID: String) throws -> CatBreedEntity? {
        let request = FetchDescriptor<CatBreedEntity>(predicate: #Predicate { $0.id == breedID })
        return try modelContext.fetch(request).first
    }
}
