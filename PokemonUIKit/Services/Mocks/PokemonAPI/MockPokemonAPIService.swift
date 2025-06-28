//
//  Untitled.swift
//  PokemonUIKit
//
//  Created by Eduardo Cordeiro da Camara on 27/06/25.
//

import Foundation

final class MockPokemonAPIService: PokemonAPIServiceProtocol {
    func fetchPokemonList(offset: Int, limit: Int, completion: @escaping (Result<[PokemonModel], any Error>) -> Void) {
        
    }
    
    func fetchPokemonDetails(ofId id: Int, completion: @escaping (Result<PokemonDetailsModel, any Error>) -> Void) {
        
    }
    
    func fetchPokemonDetails(url: URL, completion: @escaping (Result<PokemonDetailsModel, any Error>) -> Void) {
        
    }
}
