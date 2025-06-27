//
//  Untitled.swift
//  PokemonUIKit
//
//  Created by Eduardo Cordeiro da Camara on 27/06/25.
//

import Foundation

final class MockPokemonAPIService: PokemonAPIServiceProtocol {
    func fetchPokemonList(completion: @escaping (Result<[Pokemon], any Error>) -> Void) {
        
    }
    
    func fetchPokemonDetail(from url: URL, completion: @escaping (Result<PokemonDetail, any Error>) -> Void) {
        
    }
}
