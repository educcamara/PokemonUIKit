//
//  PokemonTypeModel.swift
//  PokemonUIKit
//
//  Created by Eduardo Cordeiro da Camara on 27/06/25.
//

import Foundation
import UIKit

enum PokemonTypeModel: String, Codable {
    case normal
    case fire
    case water
    case electric
    case grass
    case ice
    case fighting
    case poison
    case ground
    case flying
    case psychic
    case bug
    case rock
    case ghost
    case dragon
    case dark
    case steel
    case fairy
    
    var title: String { self.rawValue.capitalized }
    
    var color: ColorResource {
        return switch self {
        case .normal: .PokemonType.normal
        case .fire: .PokemonType.fire
        case .water: .PokemonType.water
        case .electric: .PokemonType.electric
        case .grass: .PokemonType.grass
        case .ice: .PokemonType.ice
        case .fighting: .PokemonType.fighting
        case .poison: .PokemonType.poison
        case .ground: .PokemonType.ground
        case .flying: .PokemonType.flying
        case .psychic: .PokemonType.psychic
        case .bug: .PokemonType.bug
        case .rock: .PokemonType.rock
        case .ghost: .PokemonType.ghost
        case .dragon: .PokemonType.dragon
        case .dark: .PokemonType.dark
        case .steel: .PokemonType.steel
        case .fairy: .PokemonType.fairy
        }
    }
}
