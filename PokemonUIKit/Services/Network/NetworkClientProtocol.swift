//
//  NetworkClientProtocol.swift
//  PokemonUIKit
//
//  Created by Eduardo Cordeiro da Camara on 27/06/25.
//

protocol NetworkClientProtocol {
    func fetch<T: Decodable>(
        from urlString: String,
        decodeTo type: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void)
}
