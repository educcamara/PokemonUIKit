//
//  PokemonDetailViewModelTests.swift
//  PokemonUIKitTests
//
//  Created by Eduardo Cordeiro da Camara on 27/06/25.
//

@testable import PokemonUIKit
import XCTest

final class PokemonDetailViewModelTests: XCTestCase {
    
    // Propriedades
    var mockService: MockPokemonService!
    var mockDelegate: MockPokemonDetailDelegate!
    var mockRepository: MockFavoritePokemonRepository!
    var sut: PokemonDetailsViewModel!
    var mockURL: URL!
    
    // MARK: - Setup e Teardown
    
    override func setUp() {
        super.setUp()
        mockService = MockPokemonService()
        mockDelegate = MockPokemonDetailDelegate()
        mockURL = URL(string: "https://pokeapi.co/api/v2/pokemon/1")
        mockRepository = MockFavoritePokemonRepository()
        
        sut = PokemonDetailsViewModel(
            url: mockURL,
            service: mockService,
            repository: mockRepository
        )
        sut.delegate = mockDelegate
    }
    
    override func tearDown() {
        mockService = nil
        mockDelegate = nil
        mockRepository = nil
        sut = nil
        mockURL = nil
        super.tearDown()
    }
    
    // MARK: - Fetch Detail Tests
    
    func test_fetchPokemonDetail_whenResponseIsSuccessful_shouldLoadWithCorrectPokemon() {
        // Arrange
        let expectedPokemon = createSamplePokemon()
        mockService.pokemonDetailsResult = .success(expectedPokemon)
        mockRepository.containsToBeReturned = true
        // Act
        sut.fetchPokemonDetail()
        
        // Assert
        XCTAssertTrue(mockDelegate.didLoadDetailCalled)
        XCTAssertFalse(mockDelegate.didFailCalled)
        XCTAssertEqual(mockDelegate.loadedDetail?.name, "Bulbasaur")
        XCTAssertEqual(mockDelegate.loadedDetail?.id, 1)
        XCTAssertTrue(mockDelegate.loadedIsFavorited)
    }
    
    func test_fetchPokemonDetail_whenResponseFails_shouldNotifyDelegateWithError() {
        // Arrange
        enum TestError: Error { case networkError }
        mockService.pokemonDetailsResult = .failure(TestError.networkError)
        
        // Act
        sut.fetchPokemonDetail()
        
        // Assert
        XCTAssertTrue(mockDelegate.didFailCalled)
        XCTAssertFalse(mockDelegate.didLoadDetailCalled)
        XCTAssertNotNil(mockDelegate.failedWithError)
    }
    
    func test_fetchPokemonDetail_whenURLIsNil_shouldNotifyDelegateWithError() {
        // Arrange
        sut = PokemonDetailsViewModel(
            url: nil,
            service: mockService,
            repository: mockRepository
        )
        sut.delegate = mockDelegate
        
        // Act
        sut.fetchPokemonDetail()
        
        // Assert
        XCTAssertFalse(mockDelegate.didLoadDetailCalled)
        XCTAssertTrue(mockDelegate.didFailCalled)
    }
    
    // MARK: - Favorite Tests
    
    func test_toggleFavorite_whenPokemonIsNotFavorited_shouldAddToFavorites() {
        // Arrange
        let pokemon = createSamplePokemon(name: "bulbasaur")
        mockService.pokemonDetailsResult = .success(pokemon)
        mockRepository.containsToBeReturned = false
        sut.fetchPokemonDetail()
        
        // Act
        sut.toggleFavorite()
        
        // Assert
        XCTAssertTrue(mockRepository.pokemonAddedCalled)
        XCTAssertEqual(mockRepository.pokemonAdded, "bulbasaur")
        XCTAssertFalse(mockRepository.pokemonRemovedCalled)
    }
    
    func test_toggleFavorite_whenPokemonIsFavorited_shouldRemoveFromFavorites() {
        // Arrange
        let pokemon = createSamplePokemon()
        mockService.pokemonDetailsResult = .success(pokemon)
        mockRepository.containsToBeReturned = true
        sut.fetchPokemonDetail()
        
        // Act
        sut.toggleFavorite()
        
        // Assert
        XCTAssertTrue(mockRepository.pokemonRemovedCalled)
        XCTAssertEqual(mockRepository.pokemonRemoved, "bulbasaur")
        XCTAssertFalse(mockRepository.pokemonAddedCalled)
    }
    
    func test_toggleFavorite_whenCurrentDetailIsNil_shouldDoNothing() {
        // Act
        sut.toggleFavorite()
        
        // Assert
        XCTAssertFalse(mockRepository.pokemonAddedCalled)
        XCTAssertFalse(mockRepository.pokemonRemovedCalled)
        XCTAssertNil(mockRepository.pokemonAdded)
        XCTAssertNil(mockRepository.pokemonRemoved)
    }
    
    func test_fetchPokemonDetail_whenPokemonIsFavorited_shouldPassFavoritedStatusToDelegate() {
        // Arrange
        let pokemon = createSamplePokemon()
        mockService.pokemonDetailsResult = .success(pokemon)
        
        // Primeiro carregamento - não favoritado
        mockRepository.containsToBeReturned = false
        sut.fetchPokemonDetail()
        XCTAssertFalse(mockDelegate.loadedIsFavorited)
        
        mockRepository.containsToBeReturned = true
        
        // Act - Carregar novamente
        sut.fetchPokemonDetail()
        
        // Assert
        XCTAssertTrue(mockDelegate.loadedIsFavorited)
    }
    
    func test_fetchPokemonDetail_whenLoadingDifferentPokemons_shouldHandleFavoritesCorrectly() {
        // Arrange
        let bulbasaur = createSamplePokemon(id: 1, name: "Bulbasaur")
        let pikachu = createSamplePokemon(id: 25, name: "Pikachu")
        
        // Primeiro carregamento - Bulbasaur não favoritado
        mockService.pokemonDetailsResult = .success(bulbasaur)
        mockRepository.containsToBeReturned = false
        sut.fetchPokemonDetail()
        
        XCTAssertEqual(mockDelegate.loadedDetail?.name, "Bulbasaur")
        XCTAssertFalse(mockDelegate.loadedIsFavorited )
        
        
        // Configurar para Pikachu
        mockService.pokemonDetailsResult = .success(pikachu)
        // Simular que apenas Bulbasaur está favoritado
        mockRepository.containsToBeReturned = false
        
        // Act - Carregar Pikachu
        sut.fetchPokemonDetail()
        
        // Assert
        XCTAssertEqual(mockDelegate.loadedDetail?.name, "Pikachu")
        XCTAssertEqual(mockDelegate.loadedDetail?.id, 25)
        XCTAssertFalse(mockDelegate.loadedIsFavorited)
    }
    
    func createSamplePokemon(id: Int = 1, name: String = "Bulbasaur") -> PokemonDetailsModel {
        return PokemonDetailsModel(
            id: id,
            name: name,
            imageUrl: URL(string: "https://example.com/bulbasaur.png"),
            height: 7.0,
            weight: 69.0,
            types: [.grass],
            stats: [.init(name: "hp", baseStat: 60)]
        )
    }
}
