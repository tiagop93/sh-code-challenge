//
//  JSONDecoder+Extensions.swift
//  SHCodeChallenge
//
//  Created by Tiago Pereira on 30/10/2024.
//

import Foundation

extension JSONDecoder {
    static var defaultDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
