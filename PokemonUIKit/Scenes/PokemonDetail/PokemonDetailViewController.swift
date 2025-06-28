//
//  PokemonDetailViewController.swift
//  PokemonUIKit
//
//  Created by Eduardo Cordeiro da Camara on 27/06/25.
//

import UIKit

class PokemonDetailViewController: UIViewController, PokemonDetailViewModelDelegate {
    
    private let pokemonDetailView = PokemonDetailsView()
    private let viewModel: PokemonDetailViewModel
    
    init(url: URL?) {
        self.viewModel = PokemonDetailViewModel(url: url)
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
    
    // MARK: - PokemonDetailViewModelDelegate
    
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

extension PokemonDetailViewController: PokemonDetailViewDelegate {
    func didTapFavorite() {
        viewModel.toggleFavorite()
    }
}
