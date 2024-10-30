//
//  CatDashboardViewModel.swift
//  SHCodeChallenge
//
//  Created by Tiago Pereira on 29/10/2024.
//

import Foundation
import Combine

@Observable
class CatDashboardViewModel {
    @ObservationIgnored private var apiClient: HTTPClient
    @ObservationIgnored var cancellables: Set<AnyCancellable> = []
    var searchString: String = ""
    var catBreeds: [CatBreed] = []
    
    private var currentPage = APIConstants.initialPage
    
    init(apiClient: HTTPClient) {
        self.apiClient = apiClient
        self.fetchCatBreeds()
    }
    
    private func fetchCatBreeds() {
        apiClient.fetchCatBreeds(page: currentPage)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                // TODO: Update state
                switch completion {
                case .finished:
                    ()
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { response in
                self.catBreeds.append(contentsOf: response)
            }.store(in: &cancellables)
    }
}
