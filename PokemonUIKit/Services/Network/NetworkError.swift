//
//  NetworkError.swift
//  PokemonUIKit
//
//  Created by Eduardo Cordeiro da Camara on 27/06/25.
//

enum NetworkError: Error {
    case invalidURL
    case emptyData
    case custom(any Error)
}
