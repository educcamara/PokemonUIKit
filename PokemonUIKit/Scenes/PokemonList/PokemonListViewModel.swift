//
//  PokemonListViewModel.swift
//  PokemonUIKit
//
//  Created by Eduardo Cordeiro da Camara on 27/06/25.
//

protocol PokemonListViewModelDelegate: AnyObject {
    func didUpdatePokemonList()
    func didFailWithError(_ message: String)
}

class PokemonListViewModel {
    
    weak var delegate: PokemonListViewModelDelegate?
    private let service: PokemonAPIServiceProtocol
    private(set) var pokemons: [PokemonModel] = []

    init(service: PokemonAPIServiceProtocol = PokemonAPIService()) {
        self.service = service
    }
    
    func fetchPokemons() {
        service.fetchPokemonList(offset: 0, limit: 20) { [weak self] result in
            switch result {
            case .success(let pokemons):
                self?.pokemons = pokemons
                self?.delegate?.didUpdatePokemonList()
            case .failure(let error):
                self?.delegate?.didFailWithError(error.localizedDescription)
            }
        }
    }

    func getPokemon(at index: Int) -> PokemonModel {
        return pokemons[index]
    }

    var numberOfPokemons: Int {
        return pokemons.count
    }
}
