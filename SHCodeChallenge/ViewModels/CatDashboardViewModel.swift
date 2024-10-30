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
    @ObservationIgnored private var apiClient: HTTPClient
    @ObservationIgnored var cancellables: Set<AnyCancellable> = []
    var searchString: String = ""
    var catBreeds: [CatBreed] = []
    
    private var currentPage = APIConstants.initialPage
    
    init(apiClient: HTTPClient) {
        self.apiClient = apiClient
        super.init()
    }
    
    @MainActor
    func loadDataIfNeeded() {
        guard state == .none else { return }
        self.fetchCatBreeds()
    }
    
   @MainActor
    func reloadData() {
        catBreeds = []
        currentPage = APIConstants.initialPage
        self.fetchCatBreeds()
    }
    
    @MainActor
    func searchData() {
        catBreeds = []
        self.searchCatBreeds()
    }
    
    private func fetchCatBreeds() {
        
        self.state = .loading
        
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
                self.catBreeds.append(contentsOf: response)
            }.store(in: &cancellables)
    }
    
    private func searchCatBreeds() {
        
        self.state = .loading
        
        apiClient.searchCatBreeds(searchTerm: searchString)
            .receive(on: DispatchQueue.main)
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
                self.catBreeds.append(contentsOf: response)
            }.store(in: &cancellables)
    }
}
