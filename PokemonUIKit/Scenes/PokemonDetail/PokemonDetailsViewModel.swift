//
//  PokemonDetailViewModel.swift
//  PokemonUIKit
//
//  Created by Eduardo Cordeiro da Camara on 27/06/25.
//

import Foundation

protocol PokemonDetailsViewModelDelegate: AnyObject {
    func didReceiveCachedPokemon(_ pokemon: PokemonModel)
    func didLoadPokemonDetail(detail: PokemonDetailsModel, isFavorited: Bool)
    func didFailToLoadDetail(with error: Error)
}

final class PokemonDetailsViewModel {
    //MARK: Properties
    private let url: URL?
    private let pokemon: PokemonModel?
    private let service: PokemonAPIServiceProtocol
    private let repository: FavoritePokemonRepositoryProtocol
    private var currentDetail: PokemonDetailsModel?
    
    weak var delegate: PokemonDetailsViewModelDelegate?
    
    //MARK: LifeCycle
    init(
        url: URL?,
        service: PokemonAPIServiceProtocol = PokemonAPIService(),
        repository: FavoritePokemonRepositoryProtocol = FavoritePokemonUserDefaultsRepository.shared
    ) {
        self.url = url
        self.pokemon = nil
        self.service = service
        self.repository = repository
    }
    
    init(
        pokemon: PokemonModel,
        service: PokemonAPIServiceProtocol = PokemonAPIService(),
        repository: FavoritePokemonRepositoryProtocol = FavoritePokemonUserDefaultsRepository.shared
    ) {
        self.url = pokemon.url
        self.pokemon = pokemon
        self.service = service
        self.repository = repository
    }
    
    func fetchPokemonDetail() {
        if let pokemon {
            delegate?.didReceiveCachedPokemon(pokemon)
        }
        
        guard let url = url else {
            delegate?.didFailToLoadDetail(with: NetworkError.invalidURL)
            return
        }
        
        service.fetchPokemonDetails(url: url) { [weak self] result in
            switch result {
            case .success(let detail):
                self?.currentDetail = detail
                self?.delegate?.didLoadPokemonDetail(
                    detail: detail,
                    isFavorited: self?.isFavorited() ?? false
                )
            case .failure(let error):
                self?.delegate?.didFailToLoadDetail(with: error)
            }
        }
    }
    
    func toggleFavorite() {
        guard let pokemon = currentDetail else { return }
        let name = pokemon.name.lowercased()
        
        if isFavorited() {
            repository.remove(name)
        } else {
            repository.add(name)
        }
    }
    
    private func isFavorited() -> Bool {
        guard let pokemon = currentDetail else { return false }
        return repository.contains(pokemon.name.lowercased())
    }
}

