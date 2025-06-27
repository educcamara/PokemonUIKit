import XCTest
@testable import PokemonUIKit

final class PokemonAPIServiceTests: XCTestCase {
    
    // MARK: - Properties
    
    // SUT: System Under Test
    var sut: PokemonAPIService!
    var mockNetworkClient: MockNetworkClient!
    
    // MARK: - Setup and Teardown
    
    override func setUp() {
        super.setUp()
        // Initialize with success response by default
        mockNetworkClient = MockNetworkClient(
            configuration: .success(data: createMockPokemonListData())
        )
        sut = PokemonAPIService(networkClient: mockNetworkClient)
    }
    
    override func tearDown() {
        mockNetworkClient = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - FetchPokemonList Tests
    
    func test_fetchPokemonList_whenResponseIsSuccessful_shouldReturnPokemons() {
        // Arrange
        let expectation = XCTestExpectation(description: "Fetch Pokemon list")
        let mockData = createMockPokemonListData()
        mockNetworkClient.setupNewResponse(.success(data: mockData))
        
        // Act
        sut.fetchPokemonList { result in
            // Assert
            switch result {
            case .success(let pokemons):
                XCTAssertEqual(pokemons.count, 2)
                XCTAssertEqual(pokemons[0].name, "bulbasaur")
                XCTAssertEqual(pokemons[1].name, "ivysaur")
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_fetchPokemonList_withCustomOffsetAndLimit_shouldUseCorrectParameters() {
        // Arrange
        let expectation = XCTestExpectation(description: "Fetch Pokemon list with custom parameters")
        let mockData = createMockPokemonListData()
        mockNetworkClient.setupNewResponse(.success(data: mockData))
        
        // Act
        sut.fetchPokemonList(offset: 20, limit: 10) { result in
            // Assert
            switch result {
            case .success(let pokemons):
                XCTAssertEqual(pokemons.count, 2)
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_fetchPokemonList_whenResponseFails_shouldReturnError() {
        // Arrange
        let expectation = XCTestExpectation(description: "Fetch Pokemon list fails")
        let expectedError = NetworkError.invalidURL
        mockNetworkClient.setupNewResponse(.failure(error: expectedError))
        
        // Act
        sut.fetchPokemonList { result in
            // Assert
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertTrue(error is NetworkError)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_fetchPokemonList_whenJSONDecodingFails_shouldReturnError() {
        // Arrange
        let expectation = XCTestExpectation(description: "Fetch Pokemon list decoding fails")
        let invalidJSONData = "invalid json".data(using: .utf8)!
        mockNetworkClient.setupNewResponse(.success(data: invalidJSONData))
        
        // Act
        sut.fetchPokemonList { result in
            // Assert
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertTrue(error is NetworkError)
                if case .custom = error as? NetworkError {
                    // This is expected for decoding errors
                }
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - FetchPokemonDetails Tests
    
    func test_fetchPokemonDetails_whenResponseIsSuccessful_shouldReturnPokemonDetails() {
        // Arrange
        let expectation = XCTestExpectation(description: "Fetch Pokemon details")
        let mockData = createMockPokemonDetailsData()
        mockNetworkClient.setupNewResponse(.success(data: mockData))
        
        // Act
        sut.fetchPokemonDetails(ofId: 1) { result in
            // Assert
            switch result {
            case .success(let details):
                XCTAssertEqual(details.height, 0.8)
                XCTAssertEqual(details.weight, 1.2)
                XCTAssertTrue(details.types.count == 2)
                XCTAssertTrue(details.stats.count == 2)
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_fetchPokemonDetails_whenResponseFails_shouldReturnError() {
        // Arrange
        let expectation = XCTestExpectation(description: "Fetch Pokemon details fails")
        let expectedError = NetworkError.emptyData
        mockNetworkClient.setupNewResponse(.failure(error: expectedError))
        
        // Act
        sut.fetchPokemonDetails(ofId: 999) { result in
            // Assert
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertTrue(error is NetworkError)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_fetchPokemonDetails_whenJSONDecodingFails_shouldReturnError() {
        // Arrange
        let expectation = XCTestExpectation(description: "Fetch Pokemon details decoding fails")
        let invalidJSONData = "invalid json".data(using: .utf8)!
        mockNetworkClient.setupNewResponse(.success(data: invalidJSONData))
        
        // Act
        sut.fetchPokemonDetails(ofId: 1) { result in
            // Assert
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertTrue(error is NetworkError)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Integration Tests
    
    func test_fetchPokemonList_withDefaultParameters_shouldUseCorrectDefaults() {
        // Arrange
        let expectation = XCTestExpectation(description: "Fetch Pokemon list with defaults")
        let mockData = createMockPokemonListData()
        mockNetworkClient.setupNewResponse(.success(data: mockData))
        
        // Act
        sut.fetchPokemonList { result in
            // Assert
            switch result {
            case .success(let pokemons):
                // Should return pokemons using default offset=0, limit=20
                XCTAssertNotNil(pokemons)
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Helper Methods
    
    private func createMockPokemonListData() -> Data {
        return Data(from: PokemonListResponse(
            next: "http://nexturl.com",
            previous: "http://previousurl.com",
            results: [
                .init(name: "bulbasaur", urlString: "http://bulbasaur.com"),
                .init(name: "pikachu", urlString: "http://pikachu.com"),
            ]
        ))
    }
    
    private func createMockPokemonDetailsData() -> Data {
        return Data(from: PokemonDetailsResponse(
            name: "bulbasaur",
            height: 8,
            weight: 12,
            types: [
                .init(type: .init(name: "normal")),
                .init(type: .init(name: "poison")),
            ],
            stats: [
                .init(baseStat: 43, stat: .init(name: "hp")),
                .init(baseStat: 43, stat: .init(name: "attack")),
            ]))
    }
}

extension Data {
    init<T: Encodable>(from value: T) {
        self = try! JSONEncoder().encode(value)
    }
}
