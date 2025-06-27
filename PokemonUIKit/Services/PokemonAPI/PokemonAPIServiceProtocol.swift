//
//  PokemonAPIServiceProtocol.swift
//  PokemonUIKit
//
//  Created by Eduardo Cordeiro da Camara on 27/06/25.
//

import Foundation

protocol PokemonAPIServiceProtocol {
    func fetchPokemonList(completion: @escaping (Result<[Pokemon], Error>) -> Void)
    func fetchPokemonDetail(from url: URL, completion: @escaping (Result<PokemonDetailsModel, Error>) -> Void)
}
