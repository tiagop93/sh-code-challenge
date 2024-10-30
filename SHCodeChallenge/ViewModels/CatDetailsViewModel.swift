//
//  CatDetailsViewModel.swift
//  SHCodeChallenge
//
//  Created by Tiago Pereira on 30/10/2024.
//

import Foundation
import Combine

@Observable
class CatDetailsViewModel: BaseViewModel {
    @ObservationIgnored var cancellables: Set<AnyCancellable> = []
    let catBreed: CatBreed
    
    init(catBreed: CatBreed) {
        self.catBreed = catBreed
        super.init()
    }
}
