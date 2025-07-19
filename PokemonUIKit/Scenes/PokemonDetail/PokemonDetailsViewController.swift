//
//  PokemonDetailsViewController.swift
//  PokemonUIKit
//
//  Created by Eduardo Cordeiro da Camara on 27/06/25.
//

import UIKit

class PokemonDetailsViewController: UIViewController {
    
    private let pokemonDetailView = PokemonDetailsView()
    private let viewModel: PokemonDetailsViewModel
    
    init(url: URL?) {
        self.viewModel = PokemonDetailsViewModel(url: url)
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
        self.pokemonDetailView.delegate = self
    }
    
    init(cachedPokemon pokemon: PokemonModel) {
        self.viewModel = PokemonDetailsViewModel(pokemon: pokemon)
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
        self.pokemonDetailView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = pokemonDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchPokemonDetail()
    }
}
    
// MARK: - PokemonDetailViewModelDelegate
    
extension PokemonDetailsViewController: PokemonDetailsViewModelDelegate {
    func didReceiveCachedPokemon(_ pokemon: PokemonModel) {
        DispatchQueue.main.async {
            self.pokemonDetailView.configure(with: pokemon)
        }
    }
    
    func didLoadPokemonDetail(detail: PokemonDetailsModel, isFavorited: Bool) {
        DispatchQueue.main.async {
            self.pokemonDetailView.configure(with: detail, isFavorited: isFavorited)
        }
    }
    
    func didFailToLoadDetail(with error: Error) {
        DispatchQueue.main.async {
            self.showAlert(message: "Erro ao carregar detalhe do Pokémon: \(error.localizedDescription)")
        }
    }
}

extension UIViewController {
    func showAlert(title: String = "Erro", message: String, buttonTitle: String = "OK") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default))
        present(alert, animated: true)
    }
}

extension PokemonDetailsViewController: PokemonDetailsViewDelegate {
    func didTapFavorite() {
        viewModel.toggleFavorite()
    }
}
