//
//  PokemonAPIServiceProtocol.swift
//  PokemonUIKit
//
//  Created by Eduardo Cordeiro da Camara on 27/06/25.
//

import Foundation

//TODO: Temporary Models
struct Pokemon {}
struct PokemonDetail {}

protocol PokemonServiceProtocol {
    func fetchPokemonList(completion: @escaping (Result<[Pokemon], Error>) -> Void)
    func fetchPokemonDetail(from url: URL, completion: @escaping (Result<PokemonDetail, Error>) -> Void)
}
