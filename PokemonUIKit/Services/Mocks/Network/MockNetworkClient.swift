//
//  MockNetworkClient.swift
//  PokemonUIKit
//
//  Created by Eduardo Cordeiro da Camara on 27/06/25.
//

import Foundation

final class MockNetworkClient: NetworkClientProtocol {
    
    // MARK: - Properties
    private var delay: TimeInterval
    private var response: Response
    
    enum Response {
        case success(data: Data)
        case failure(error: Error)
    }
    
    //MARK: - Init
    init(
        delay: TimeInterval = 0,
        configuration: Response,
    ) {
        self.delay = delay
        self.response = configuration
    }
    
    
    // MARK: - NetworkClientProtocol Implementation
    func fetch<T: Decodable>(
        from urlString: String,
        decodeTo type: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        DispatchQueue.global().asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self else { return }
            
            switch self.response {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let decoded = try decoder.decode(type, from: data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(.custom(error)))
                }
            case .failure(let error):
                if let networkError = error as? NetworkError {
                    completion(.failure(networkError))
                } else {
                    completion(.failure(.custom(error)))
                }
            }
        }
    }
}

// MARK: - Helpers
extension MockNetworkClient {
    func setupNewResponse(_ response: Response, delay: TimeInterval = 0) {
        self.delay = delay
        self.response = response
    }
}
