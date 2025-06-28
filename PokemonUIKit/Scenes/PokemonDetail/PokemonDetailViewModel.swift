//
//  PokemonDetailViewModel.swift
//  PokemonUIKit
//
//  Created by Eduardo Cordeiro da Camara on 27/06/25.
//

import Foundation

protocol PokemonDetailViewModelDelegate: AnyObject {
    func didLoadPokemonDetail(detail: PokemonDetailsModel, isFavorited: Bool)
    func didFailToLoadDetail(with error: Error)
}

final class PokemonDetailViewModel {
    private let service: PokemonAPIServiceProtocol
    private let url: URL?
    private let repository: FavoritePokemonRepositoryProtocol
    
    weak var delegate: PokemonDetailViewModelDelegate?
    private var currentDetail: PokemonDetailsModel?
    
    init(
        url: URL?,
        service: PokemonAPIServiceProtocol = PokemonAPIService(),
        repository: FavoritePokemonRepositoryProtocol = FavoritePokemonUserDefaultsRepository.shared
    ) {
        self.url = url
        self.service = service
        self.repository = repository
    }
    
    func fetchPokemonDetail() {
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

