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
        case normal
        case search
    }
    
    @ObservationIgnored private var apiClient: HTTPClient
    @ObservationIgnored var cancellables: Set<AnyCancellable> = []
    
    var searchString: String = ""
    var catBreeds: [CatBreed] = []
    
    private var currentPage = APIConstants.initialPage
    private let loadNextPageSubject = PassthroughSubject<Void, Never>()
    private var mode: Mode = .normal
    
    init(apiClient: HTTPClient) {
        self.apiClient = apiClient
        super.init()
        self.setupPaginationListener()
    }
    
    // MARK: - Public Methods
    
    @MainActor
    func loadDataIfNeeded() {
        guard state == .none, mode == .normal else { return }
        state = .loading
        self.fetchCatBreeds()
    }
    
    @MainActor
    func reloadData() {
        catBreeds = []
        currentPage = APIConstants.initialPage
        mode = .normal
        state = .loading
        self.fetchCatBreeds()
    }
    
    @MainActor
    func searchData() {
        catBreeds = []
        currentPage = APIConstants.initialPage
        mode = .search
        state = .loading
        self.searchCatBreeds()
    }
    
    func triggerLoadNextPage() {
        guard mode == .normal else { return }
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
                self.catBreeds.append(contentsOf: response)
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
                self.catBreeds = response
            }.store(in: &cancellables)
    }
    
    @MainActor
    private func loadNextPage() {
        guard state != .loading, mode == .normal else { return }
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
}
