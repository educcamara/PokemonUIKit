//
//  PokemonAPIServiceProtocol.swift
//  PokemonUIKit
//
//  Created by Eduardo Cordeiro da Camara on 27/06/25.
//

import Foundation

protocol PokemonAPIServiceProtocol {
    func fetchPokemonList(offset: Int, limit: Int, completion: @escaping (Result<[PokemonModel], Error>) -> Void)
    func fetchPokemonDetail(from url: URL, completion: @escaping (Result<PokemonDetailsModel, Error>) -> Void)
}
