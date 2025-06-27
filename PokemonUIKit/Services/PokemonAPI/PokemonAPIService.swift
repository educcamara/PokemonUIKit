//
//  PokemonAPIService.swift
//  PokemonUIKit
//
//  Created by Eduardo Cordeiro da Camara on 27/06/25.
//

import Foundation

final class PokemonAPIService: PokemonAPIServiceProtocol {
    let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    func fetchPokemonList(offset: Int = 0, limit: Int = 20, completion: @escaping (Result<[PokemonModel], any Error>) -> Void) {
        let urlString = "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)"
        
        networkClient.fetch(from: urlString, decodeTo: PokemonListResponse.self) { result in
            switch result {
            case .success(let response):
                let pokemons = response.results.map { $0.toDomainModel() }
                completion(.success(pokemons))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchPokemonDetails(ofId id: Int, completion: @escaping (Result<PokemonDetail{sModel, any Error>) -> Void) {
        let urlString = "https://pokeapi.co/api/v2/pokemon/\(id)"
        
//        networkClient.fetch(from: urlString, decodeTo: PokemonDetailsResponse.self) { result in
//            switch result {
//            case .success(let response):
//                let details = response.toDomainModel()
//                completion(.success(details))
//            case .failure(let error):
//            }
//        }
    }
}
