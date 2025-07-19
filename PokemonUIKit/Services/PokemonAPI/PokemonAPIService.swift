//
//  PokemonAPIService.swift
//  PokemonUIKit
//
//  Created by Eduardo Cordeiro da Camara on 27/06/25.
//

import Foundation

final class PokemonAPIService: PokemonAPIServiceProtocol {
    
    let networkClient: NetworkClientProtocol
    var cursor = (offset: 0, limit: 20)

    init(networkClient: NetworkClientProtocol = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    func fetchPokemonList(offset: Int = 0, limit: Int = 20, completion: @escaping (Result<[PokemonModel], any Error>) -> Void) {
        let urlString = PokemonAPIEndpoint.pokemonList(limit: limit, offset: offset).absoluteString
        
        networkClient.fetch(from: urlString, decodeTo: PokemonListResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                let pokemons = response.results.map { $0.toDomainModel() }
                self?.cursor = (offset: offset + limit, limit: limit)
                completion(.success(pokemons))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchNextPokemonPage(limit: Int = 20, completion: @escaping (Result<[PokemonModel], any Error>) -> Void) {
        let urlString = PokemonAPIEndpoint.pokemonList(limit: limit, offset: cursor.offset).absoluteString
        
        networkClient.fetch(from: urlString, decodeTo: PokemonListResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                let pokemons = response.results.map { $0.toDomainModel() }
                if let self {
                    self.cursor = (offset: self.cursor.offset + limit, limit: limit)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchPokemonDetails(ofId id: Int, completion: @escaping (Result<PokemonDetailsModel, any Error>) -> Void) {
        let urlString = PokemonAPIEndpoint.pokemonDetails(for: id).absoluteString
        
        networkClient.fetch(from: urlString, decodeTo: PokemonDetailsResponse.self) { result in
            switch result {
            case .success(let response):
                let details = response.toDomainModel()
                completion(.success(details))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchPokemonDetails(url: URL, completion: @escaping (Result<PokemonDetailsModel, any Error>) -> Void) {
        networkClient.fetch(from: url.absoluteString, decodeTo: PokemonDetailsResponse.self) { result in
            switch result {
            case .success(let response):
                let details = response.toDomainModel()
                completion(.success(details))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
