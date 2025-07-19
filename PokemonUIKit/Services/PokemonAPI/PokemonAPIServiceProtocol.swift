//
//  PokemonAPIServiceProtocol.swift
//  PokemonUIKit
//
//  Created by Eduardo Cordeiro da Camara on 27/06/25.
//

import Foundation

protocol PokemonAPIServiceProtocol {
    func fetchPokemonList(offset: Int, limit: Int, completion: @escaping (Result<[PokemonModel], Error>) -> Void)
    func fetchNextPokemonPage(limit: Int, completion: @escaping (Result<[PokemonModel], any Error>) -> Void)
    func fetchPokemonDetails(ofId id: Int, completion: @escaping (Result<PokemonDetailsModel, Error>) -> Void)
    func fetchPokemonDetails(url: URL, completion: @escaping (Result<PokemonDetailsModel, Error>) -> Void)
}
