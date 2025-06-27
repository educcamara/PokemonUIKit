import Foundation
import UIKit

enum PokemonType: String, Codable {
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

extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8 * 4), (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, (int >> 8) & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
