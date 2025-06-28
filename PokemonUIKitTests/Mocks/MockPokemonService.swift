//
//  MockPokemonService.swift
//  PokemonUIKitTests
//
//  Created by Eduardo Cordeiro da Camara on 27/06/25.
//

@testable import PokemonUIKit
import Foundation

final class MockPokemonService: PokemonServiceProtocol {
    var result: Result<[Pokemon], Error>?
    
    func fetchPokemonList(completion: @escaping (Result<[Pokemon], Error>) -> Void) {
        if let result = result {
            completion(result)
        }
    }
    
    var pokemonDetailResult: Result<PokemonDetail, Error>?
    
    func fetchPokemonDetail(from url: URL, completion: @escaping (Result<PokemonDetail, Error>) -> Void) {
        if let result = pokemonDetailResult {
            completion(result)
        }
    }
}

