//
//  PokemonDetailsModel.swift
//  PokemonUIKit
//
//  Created by Eduardo Cordeiro da Camara on 27/06/25.
//

import Foundation

struct PokemonDetailsModel {
    let id: Int
    let name: String
    let imageUrl: URL?
    
    /// Height in meters
    let height: Double
    /// Weight in kilograms
    let weight: Double
    let types: [PokemonTypeModel]
    let stats: [PokemonStatModel]
}
