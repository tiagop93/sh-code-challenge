//
//  BaseViewModel.swift
//  SHCodeChallenge
//
//  Created by Tiago Pereira on 30/10/2024.
//

import Foundation

@Observable
class BaseViewModel {
    
    // MARK: - State Enum
    
    enum State: Equatable {
        case none
        case loading
        case success
        case failed
    }
    
    // MARK: - Properties
    
    var state: State = .none
}

