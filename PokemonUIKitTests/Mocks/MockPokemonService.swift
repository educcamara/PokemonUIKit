//
//  MockPokemonService.swift
//  PokemonUIKitTests
//
//  Created by Eduardo Cordeiro da Camara on 27/06/25.
//

@testable import PokemonUIKit
import Foundation

final class MockPokemonService: PokemonAPIServiceProtocol {
    var result: Result<[PokemonModel], Error>?
    var pokemonDetailsResult: Result<PokemonUIKit.PokemonDetailsModel, Error>?
    
    func fetchPokemonList(offset: Int, limit: Int, completion: @escaping (Result<[PokemonUIKit.PokemonModel], any Error>) -> Void) {
        if let result = result {
            completion(result)
        }
    }
    
    func fetchPokemonDetails(ofId id: Int, completion: @escaping (Result<PokemonUIKit.PokemonDetailsModel, any Error>) -> Void) {
        if let result = pokemonDetailsResult {
            completion(result)
        }
    }
    
    func fetchPokemonDetails(url: URL, completion: @escaping (Result<PokemonUIKit.PokemonDetailsModel, any Error>) -> Void) {
        if let result = pokemonDetailsResult {
            completion(result)
        }
    }
}

