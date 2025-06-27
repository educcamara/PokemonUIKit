//
//  PokemonListResponse.swift
//  PokemonUIKit
//
//  Created by Eduardo Cordeiro da Camara on 27/06/25.
//

import Foundation

struct PokemonListResponse: Decodable {
    let next: String?
    let previous: String?
    let results: [PokemonListItemResponse]
}

struct PokemonListItemResponse: Decodable {
    let name: String
    let urlString: String
    
    private enum CodingKeys: String, CodingKey {
        case name
        case urlString = "url"
    }
}
