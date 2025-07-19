//
//  PokemonDetailsModel+Mock.swift
//  PokemonUIKit
//
//  Created by Eduardo Cordeiro da Camara on 28/06/25.
//

import Foundation

extension PokemonDetailsModel {
    static let mockBulbasaur = PokemonDetailsModel(
        id: 1,
        name: "bulbasaur",
        imageUrl: URL(pokemonImageWithId: 1),
        height: 0.7,
        weight: 6.9,
        types: [
            .grass,
            .poison
        ],
        stats: [
            .init(name: "hp", baseStat: 45),
            .init(name: "attack", baseStat: 49),
            .init(name: "defense", baseStat: 49),
            .init(name: "special-attack", baseStat: 65),
            .init(name: "special-defense", baseStat: 65),
            .init(name: "speed", baseStat: 45)
        ]
    )
    
    static let mockMewtwo = PokemonDetailsModel(
        id: 150,
        name: "mewtwo",
        imageUrl: URL(pokemonImageWithId: 150),
        height: 2.0,
        weight: 122.0,
        types: [
            .psychic
        ],
        stats: [
            .init(name: "hp", baseStat: 106),
            .init(name: "attack", baseStat: 110),
            .init(name: "defense", baseStat: 90),
            .init(name: "special-attack", baseStat: 154),
            .init(name: "special-defense", baseStat: 90),
            .init(name: "speed", baseStat: 130)
        ]
    )
}
