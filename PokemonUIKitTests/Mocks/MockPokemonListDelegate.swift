//
//  MockPokemonListDelegate.swift
//  PokemonUIKitTests
//
//  Created by Eduardo Cordeiro da Camara on 27/06/25.
//

@testable import PokemonUIKit

final class MockPokemonListDelegate: PokemonListViewModelDelegate {
       var didUpdateCalled = false
       var didFailCalled = false
       var errorMessage: String?

       func didUpdatePokemonList() {
           didUpdateCalled = true
       }

       func didFailWithError(_ message: String) {
           didFailCalled = true
           errorMessage = message
       }
   }


final class MockPokemonDetailDelegate: PokemonDetailsViewModelDelegate {
    var didLoadDetailCalled = false
    var didFailCalled = false
    var loadedDetail: PokemonDetailsModel?
    var loadedIsFavorited: Bool = false
    var failedWithError: Error?
    
    func didLoadPokemonDetail(detail: PokemonDetailsModel, isFavorited: Bool) {
        didLoadDetailCalled = true
        loadedDetail = detail
        loadedIsFavorited = isFavorited
    }
    
    func didFailToLoadDetail(with error: Error) {
        didFailCalled = true
        failedWithError = error
    }
}
