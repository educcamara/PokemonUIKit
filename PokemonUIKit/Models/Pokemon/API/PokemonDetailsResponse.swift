//
//  PokemonDetailsResponse.swift
//  PokemonUIKit
//
//  Created by Eduardo Cordeiro da Camara on 27/06/25.
//

struct PokemonDetailsResponse: Decodable {
    let name: String
    /// Height in decimeters (10:1m)
    let height: Int
    /// Weight in hectograms (1:100g)
    let weight: Int
    let types: [TypeElementResponse]
    let stats: [StatElementResponse]
}

struct TypeElementResponse: Decodable {
    let type: TypeInfoResponse
}

struct TypeInfoResponse: Decodable {
    let name: String
}

struct StatElementResponse: Decodable {
    let baseStat: Int
    let stat: StatInfoResponse
}

struct StatInfoResponse: Decodable {
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
        
        return PokemonDetailsModel(
            height: Double(height)/10,
            weight: Double(weight)/10,
            types: types,
            stats: stats)
    }
}
