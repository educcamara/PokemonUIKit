//
//  PokemonAPIEndpoint.swift
//  PokemonUIKit
//
//  Created by Eduardo Cordeiro da Camara on 19/07/25.
//

import Foundation

enum PokemonAPIEndpoint {
    // "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
    static func pokemonImage(for id: Int) -> URL {
        URLBuilder()
            .httpsScheme()
            .domain("raw.githubusercontent.com")
            .appendingPath("PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png")
            .build()!
    }
    
    // "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)"
    static func pokemonList(limit: Int, offset: Int) -> URL {
        URLBuilder()
            .httpsScheme()
            .domain("pokeapi.co")
            .appendingPath("api/v2/pokemon")
            .appendingQuery(key: "limit", value: "\(limit)")
            .appendingQuery(key: "offset", value: "\(offset)")
            .build()!
    }
    
    // "https://pokeapi.co/api/v2/pokemon/\(id)"
    static func pokemonDetails(for id: Int) -> URL {
        URLBuilder()
            .httpsScheme()
            .domain("pokeapi.co")
            .appendingPath("api/v2/pokemon/\(id)")
            .build()! 
    }
}
