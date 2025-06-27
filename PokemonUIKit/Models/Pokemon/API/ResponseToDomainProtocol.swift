//
//  ResponseToDomainProtocol.swift
//  PokemonUIKit
//
//  Created by Eduardo Cordeiro da Camara on 27/06/25.
//

/// Protocol for converting API response models to domain models.
/// Provides a standard interface for transforming network data into business logic models.
protocol ResponseToDomainProtocol {
   associatedtype DomainModel
   
   func toDomainModel() -> DomainModel
}
