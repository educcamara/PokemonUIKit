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

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                completion(.failure(.custom(error)))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse,
               200...299 ~= httpResponse.statusCode {
                completion(.failure(NetworkError.invalidResponse))
            }

            guard let data = data else {
                completion(.failure(NetworkError.emptyData))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(.custom(error)))
            }
        }.resume()
    }
}
