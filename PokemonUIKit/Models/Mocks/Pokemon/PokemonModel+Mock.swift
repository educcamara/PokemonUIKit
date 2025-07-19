//
//  PokemonModel+Mock.swift
//  PokemonUIKit
//
//  Created by Eduardo Cordeiro da Camara on 28/06/25.
//

import Foundation

extension PokemonModel {
    static let mockBulbasaur = PokemonModel(
        id: 1,
        name: "bulbasaur",
        imageUrl: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png"),
        url: URL(string: "https://pokeapi.co/api/v2/pokemon/1/")
    )
    
    static let mockMewtwo = PokemonModel(
        id: 150,
        name: "mewtwo",
        imageUrl: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/150.png"),
        url: URL(string: "https://pokeapi.co/api/v2/pokemon/150/")
    )
    
    static let mockGyarados = PokemonModel(
        id: 130,
        name: "gyarados",
        imageUrl: URL(pokemonImageWithId: 130),
        url: URL(string: "https://pokeapi.co/api/v2/pokemon/130/")
    )
}
