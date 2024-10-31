//
//  NetworkReachability.swift
//  SHCodeChallenge
//
//  Created by Tiago Pereira on 31/10/2024.
//

import Foundation
import Network

protocol NetworkReachability {
    var isConnected: Bool { get }
}

// MARK: - DefaultNetworkReachability

class DefaultNetworkReachability: NetworkReachability {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private var currentStatus: Bool = false
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.currentStatus = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }
    
    var isConnected: Bool {
        return currentStatus
    }
}

