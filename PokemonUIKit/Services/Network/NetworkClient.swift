//
//  NetworkClient.swift
//  PokemonUIKit
//
//  Created by Eduardo Cordeiro da Camara on 27/06/25.
//

import Foundation

final class NetworkClient {
    //MARK: Properties
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
        
        //Automatic snake_case to camelCase conversion
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
}

//MARK: NetworkClientProtocol implementation
extension NetworkClient: NetworkClientProtocol {
    func fetch<T: Decodable>(
        from urlString: String,
        decodeTo type: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url, timeoutInterval: 10)
        request.httpMethod = "GET"

        session.dataTask(with: request) { [weak self] data, response, error in
            guard let self else { return }
            if let error {
                logger.warning("Error fetching data: \(error) [\(error.localizedDescription)]")
                completion(.failure(.custom(error)))
                return
            }

            guard let data else {
                logger.warning("No data returned from the server")
                completion(.failure(NetworkError.emptyData))
                return
            }

            do {
                let decoded = try self.decoder.decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                logger.warning("Could not decode data from server")
                completion(.failure(.custom(error)))
            }
        }.resume()
    }
}

//MARK: - Logger
import os.log

private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "NetworkClient")
