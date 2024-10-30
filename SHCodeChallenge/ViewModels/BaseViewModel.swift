//
//  BaseViewModel.swift
//  SHCodeChallenge
//
//  Created by Tiago Pereira on 30/10/2024.
//

import Foundation

@Observable
class BaseViewModel {
    enum State: Equatable {
        case none
        case loading
        case success
        case failed
    }
    
    var state: State = .none
}

