//
//  PokemonTableViewCell.swift
//  PokemonUIKit
//
//  Created by Eduardo Cordeiro da Camara on 27/06/25.
//

import UIKit

final class PokemonTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    static var identifier: String {
        return String(describing: self)
    }

    private let customView: PokemonCellView = {
        let view = PokemonCellView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupCustomView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        customView.prepareForReuse()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        customView.setSelected(selected, animated: animated)
    }
    
    //MARK: - Configuration
    
    func configure(with pokemon: PokemonModel) {
        customView.configure(with: pokemon)
    }
    
    //MARK: - Private Methods
    
    private func setupCustomView() {
        contentView.addSubview(customView)
        customView.pin(
            edgesAndPadding: [
                .horizontal: 16,
                .vertical: 4,
            ],
            to: contentView.safeAreaLayoutGuide)
    }
}
