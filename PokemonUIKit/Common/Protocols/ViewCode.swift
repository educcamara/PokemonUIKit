//
//  ViewCode.swift
//  PokemonUIKit
//
//  Created by Eduardo Cordeiro da Camara on 29/06/25.
//

protocol ViewCode {
    func addSubviews()
    func setupConstraints()
    func setupStyle()
}

extension ViewCode {
    func setup() {
        addSubviews()
        setupConstraints()
        setupStyle()
    }
}
