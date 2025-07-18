//
//  PokemonDetailsResponse.swift
//  PokemonUIKit
//
//  Created by Eduardo Cordeiro da Camara on 27/06/25.
//

import Foundation

struct PokemonDetailsResponse: Codable {
    let id: Int
    let name: String
    /// Height in decimeters (10:1m)
    let height: Int
    /// Weight in hectograms (1:100g)
    let weight: Int
    let types: [TypeElementResponse]
    let stats: [StatElementResponse]
}

struct TypeElementResponse: Codable {
    let type: TypeInfoResponse
}

struct TypeInfoResponse: Codable {
    let name: String
}

struct StatElementResponse: Codable {
    let baseStat: Int
    let stat: StatInfoResponse
}

struct StatInfoResponse: Codable {
    let name: String
}

//MARK: Response to DomainModel
extension PokemonDetailsResponse: ResponseToDomainProtocol {
    func toDomainModel() -> PokemonDetailsModel {
        let types = types.compactMap {
            PokemonTypeModel(rawValue: $0.type.name)
        }
        let stats = stats.map {
            PokemonStatModel(name: $0.stat.name, baseStat: $0.baseStat)
        }
        let imageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
        
        return PokemonDetailsModel(
            id: id,
            name: name,
            imageUrl: URL(string: imageUrl),
            height: Double(height)/10,
            weight: Double(weight)/10,
            types: types,
            stats: stats)
    }
}
