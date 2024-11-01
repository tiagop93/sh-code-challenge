//
//  CatDashboardViewModel.swift
//  SHCodeChallenge
//
//  Created by Tiago Pereira on 29/10/2024.
//

import Foundation
import Combine

@Observable
class CatDashboardViewModel: BaseViewModel {
    enum Mode {
        case live
        case search
        case offline
    }
    
    @ObservationIgnored private let apiClient: HTTPClient
    @ObservationIgnored private let dataStore: CatBreedDataPersistence
    @ObservationIgnored var cancellables: Set<AnyCancellable> = []
    
    var searchString: String = ""
    var catBreeds: [CatBreed] = []
    
    private var currentPage = APIConstants.initialPage
    private let loadNextPageSubject = PassthroughSubject<Void, Never>()
    private var mode: Mode = .live
    
    init(apiClient: HTTPClient, dataStore: CatBreedDataPersistence) {
        self.apiClient = apiClient
        self.dataStore = dataStore
        super.init()
        self.setupPaginationListener()
    }
    
    // MARK: - Public Methods
    
    @MainActor
    func loadDataIfNeeded() {
        guard state == .none, mode == .live else { return }
        state = .loading
        self.fetchCatBreeds()
    }
    
    @MainActor
    func reloadData() {
        catBreeds = []
        currentPage = APIConstants.initialPage
        state = .loading
        self.fetchCatBreeds()
    }
    
    @MainActor
    func searchData() {
        catBreeds = []
        currentPage = APIConstants.initialPage
        state = .loading
        self.searchCatBreeds()
    }
    
    func toggleFavorite(for breed: CatBreed) {
        if let index = catBreeds.firstIndex(where: { $0.id == breed.id }) {
            catBreeds[index].isFavorite.toggle()
        }
        
        dataStore.toggleFavoriteStatus(for: breed.id)
    }
    
    func getFavoriteBreeds() -> [CatBreed] {
        let favoriteCatBreeds = dataStore.fetchFavorites()
        
        return favoriteCatBreeds.map { catBreedEntity in
            CatBreed(catBreedEntity: catBreedEntity)
        }
    }
    
    func triggerLoadNextPage() {
        guard mode == .live else { return }
        loadNextPageSubject.send(())
    }
    
    func isLastCatBreed(_ catBreed: CatBreed) -> Bool {
        catBreed.id == catBreeds.last?.id
    }
    
    // MARK: - Private Methods
    
    private func fetchCatBreeds() {
        apiClient.fetchCatBreeds(page: currentPage)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    self.state = .success
                case .failure(let error):
                    print(error)
                    self.state = .failed
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.catBreeds.append(contentsOf: mapResponseToCatBreeds(response.data))
                self.mode = (response.source == .online) ? .live : .offline
            }.store(in: &cancellables)
    }
    
    private func searchCatBreeds() {
        apiClient.searchCatBreeds(searchTerm: searchString)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    self.state = .success
                case .failure(let error):
                    print(error)
                    self.state = .failed
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.catBreeds.append(contentsOf: mapResponseToCatBreeds(response.data))
                self.mode = (response.source == .online) ? .search : .offline
            }.store(in: &cancellables)
    }
    
    @MainActor
    private func loadNextPage() {
        guard state != .loading, mode == .live else { return }
        currentPage += 1
        fetchCatBreeds()
    }
    
    private func setupPaginationListener() {
        loadNextPageSubject
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] in
                Task { @MainActor [weak self] in
                    self?.loadNextPage()
                }
            }
            .store(in: &cancellables)
    }
    
    private func mapResponseToCatBreeds(_ catBreedResponse: [CatBreedResponse]) -> [CatBreed] {
        let savedCatBreeds = dataStore.fetchCatBreeds(for: catBreedResponse)
        return catBreedResponse.map { catBreedResponse in
            let isFavorite = savedCatBreeds.first { $0.id == catBreedResponse.id }?.isFavorite ?? false
            return CatBreed(catBreedResponse: catBreedResponse, isFavorite: isFavorite)
        }
    }
}
