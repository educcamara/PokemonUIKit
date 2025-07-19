//
//  URL+pokemonImage.swift
//  PokemonUIKit
//
//  Created by Eduardo Cordeiro da Camara on 28/06/25.
//

import Foundation

extension URL {
    init?(pokemonImageWithId id: Int) {
        self.init(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png")
    }
}
