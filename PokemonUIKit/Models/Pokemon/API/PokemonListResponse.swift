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

//MARK: Reponse to DomainModel
extension PokemonListItemResponse {
    func toDomainModel() -> PokemonModel {
        let id: Int = extractPokemonId(from: self.urlString) ?? 0
        let imageUrl = URL(string: imageUrlString(with: id))
        let url = URL(string: self.urlString)
        
        return PokemonModel(
            id: id,
            name: self.name,
            imageUrl: imageUrl,
            url: url)
    }
    
    /// Extracts the Pokemon ID from a PokeAPI URL string.
    /// - Parameter urlString: The API URL (e.g., "https://pokeapi.co/api/v2/pokemon/25/")
    /// - Returns: The Pokemon ID as an integer, or nil if extraction fails
    private func extractPokemonId(from urlString: String) -> Int? {
       let components = urlString.split(separator: "/")
       guard let last = components.last else { return nil }
       if last.isEmpty {
           return Int(components[components.count - 2])
       } else {
           return Int(last)
       }
    }
    
    private func imageUrlString(with id: Int) -> String {
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
    }
}
