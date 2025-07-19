//
//  PokemonCellView.swift
//  PokemonUIKit
//
//  Created by Eduardo Cordeiro da Camara on 27/06/25.
//

import UIKit
import SwiftUICore

class PokemonCellView: UIView {
    
    //MARK: - Components
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.layer.cornerCurve = .continuous
        
        return view
    }()
    
    private let pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, numberLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Dependency Injection
    func configure(with pokemon: PokemonModel) {
        nameLabel.text = pokemon.name.capitalized
        numberLabel.text = String(format: "#%03d", pokemon.id)
        
        if let urlString = pokemon.imageUrl?.absoluteString {
            animateImageDownload(with: urlString)
        }
    }
    
    func prepareForReuse() {
        nameLabel.text = nil
        numberLabel.text = nil
        pokemonImageView.image = nil
    }
    
    func setSelected(_ selected: Bool, animated: Bool) {
        let action: () -> Void = {
            if selected {
                self.containerView.backgroundColor = .systemGray5
            } else {
                self.containerView.backgroundColor = .systemBackground
            }
        }
        
        if animated {
            UIView.animate(withDuration: 0.15, animations: action)
        } else {
            action()
        }
    }
}

//MARK: - ViewCode Implementation

extension PokemonCellView: ViewCode {
    func addSubviews() {
        addSubview(containerView)
        containerView.addSubview(pokemonImageView)
        containerView.addSubview(infoStackView)
    }
    
    func setupConstraints() {
        containerView.pin(to: self)
        
        NSLayoutConstraint.activate([
            pokemonImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            pokemonImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            pokemonImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            pokemonImageView.widthAnchor.constraint(equalToConstant: 90),
            pokemonImageView.heightAnchor.constraint(equalToConstant: 90),
            
            infoStackView.leadingAnchor.constraint(equalTo: pokemonImageView.trailingAnchor, constant: 16),
            infoStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            infoStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
        ])
    }
    
    func setupStyle() {
        containerView.backgroundColor = .systemBackground
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 4
    }
}

//MARK: - Private Methods

private extension PokemonCellView {
    func animateImageDownload(with urlString: String) {
        // Before loading
        pokemonImageView.transform = CGAffineTransform(translationX: -100, y: 0)
        pokemonImageView.layer.opacity = 0
        
        pokemonImageView.loadImage(urlString: urlString) { _ in
            // After loading
            DispatchQueue.main.async {
                if #available(iOS 18.0, *) {
                    UIView.animate(Animation.smooth(duration: 0.6, extraBounce: 0.2)) { [weak self] in
                        self?.pokemonImageView.transform = .identity
                        self?.pokemonImageView.layer.opacity = 1
                    }
                } else {             UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut]) { [weak self] in
                    self?.pokemonImageView.transform = .identity
                    self?.pokemonImageView.layer.opacity = 1
                }
                }
            }
        }
    }
}

#if DEBUG
//MARK: - Preview
private class PokemonCellViewController: UIViewController {
    let pokemons: [PokemonModel]
    
    init(pokemons: [PokemonModel]) {
        self.pokemons = pokemons
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        let pokemonViews: [PokemonCellView] = pokemons.map { pokemon in
            let view = PokemonCellView()
            view.configure(with: pokemon)
            view.heightAnchor.constraint(equalToConstant: 100).isActive = true
            
            return view
        }
        
        let stackView = UIStackView(arrangedSubviews: pokemonViews)
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(stackView)
        stackView.pin(edges: .horizontal, to: view.safeAreaLayoutGuide, withPadding: 16)
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
        view.backgroundColor = .systemGray6
    }
}

@available(iOS 17.0, *)
#Preview {
    PokemonCellViewController(pokemons: [
        .mockBulbasaur,
        .mockGyarados,
        .mockMewtwo,
    ])
}
#endif
