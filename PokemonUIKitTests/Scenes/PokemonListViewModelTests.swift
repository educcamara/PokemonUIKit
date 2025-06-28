//
//  PokemonListViewModelTests.swift
//  PokemonUIKitTests
//
//  Created by Eduardo Cordeiro da Camara on 27/06/25.
//

@testable import PokemonUIKit
import XCTest

final class PokemonListViewModelTests: XCTestCase {
    private var sut: PokemonListViewModel!
    private var mockService: MockPokemonService!
    private var mockDelegate: MockPokemonListDelegate!
    
    override func setUp() {
        super.setUp()
        mockService = MockPokemonService()
        mockDelegate = MockPokemonListDelegate()
        sut = PokemonListViewModel(service: mockService)
        sut.delegate = mockDelegate
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_fetchPokemons_whenSuccess_shouldNotifyDelegateAndStoreData() {
            // Given
            let pokemon = PokemonModel(
                id: 1,
                name: "bulbasaur",
                imageUrl:  URL(string: "http://pokemon.com/bulbasaur.png"),
                url: URL(string: "https://pokeapi.co/api/v2/pokemon/1/")
            )
            mockService.result = .success([pokemon])

            // When
            sut.fetchPokemons()

            // Then
            XCTAssertTrue(mockDelegate.didUpdateCalled)
            XCTAssertEqual(sut.numberOfPokemons, 1)
            XCTAssertEqual(sut.getPokemon(at: 0).name, "bulbasaur")
            XCTAssertEqual(sut.getPokemon(at: 0).id, 1)
            XCTAssertEqual(sut.getPokemon(at: 0).url, URL(string: "https://pokeapi.co/api/v2/pokemon/1/"))
        }

        func test_fetchPokemons_whenFailure_shouldNotifyDelegateWithError() {
            // Given
            mockService.result = .failure(NetworkError.emptyData)

            // When
            sut.fetchPokemons()

            // Then
            XCTAssertTrue(mockDelegate.didFailCalled)
            XCTAssertEqual(mockDelegate.errorMessage, NetworkError.emptyData.localizedDescription)
        }

        func test_numberOfPokemons_shouldReturnCorrectCount() {
            mockService.result = .success([
                .init(id: 0, name: "a", imageUrl: nil, url: nil),
                .init(id: 0, name: "b", imageUrl: nil, url: nil),
                .init(id: 0, name: "c", imageUrl: nil, url: nil),
                .init(id: 0, name: "d", imageUrl: nil, url: nil),
            ])
            
            // When
            sut.fetchPokemons()
            
            // Then
            XCTAssertEqual(sut.numberOfPokemons, 4)
        }

        func test_pokemonAt_shouldReturnCorrectPokemon() {
            // Given
            let mewtwo = PokemonModel(
                id: 150,
                name: "mewtwo",
                imageUrl: URL(string: "http://pokemon.com/mewtwo.png"),
                url: nil)
            
            mockService.result = .success([mewtwo])

            // When
            sut.fetchPokemons()
            let result = sut.getPokemon(at: 0)

            // Then
            XCTAssertEqual(result.id, 150)
            XCTAssertEqual(result.name, "mewtwo")
        }
}
