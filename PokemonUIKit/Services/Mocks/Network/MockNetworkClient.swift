//
//  MockNetworkClient.swift
//  PokemonUIKit
//
//  Created by Eduardo Cordeiro da Camara on 27/06/25.
//

import Foundation

final class MockNetworkClient: NetworkClientProtocol {
   
   // MARK: - Properties
   var shouldReturnError = false
   var errorToReturn: NetworkError = .invalidURL
   var dataToReturn: Data?
   var responseDelay: TimeInterval = 0.0
   
   // MARK: - NetworkClientProtocol Implementation
   func fetch<T: Decodable>(
       from urlString: String,
       decodeTo type: T.Type,
       completion: @escaping (Result<T, NetworkError>) -> Void
   ) {
       // Simulate network delay if specified
       DispatchQueue.global().asyncAfter(deadline: .now() + responseDelay) {
           if self.shouldReturnError {
               completion(.failure(self.errorToReturn))
               return
           }
           
           guard let data = self.dataToReturn else {
               completion(.failure(.emptyData))
               return
           }
           
           do {
               let decoder = JSONDecoder()
               decoder.keyDecodingStrategy = .convertFromSnakeCase
               let decoded = try decoder.decode(type, from: data)
               completion(.success(decoded))
           } catch {
               completion(.failure(.custom(error)))
           }
       }
   }
}

// MARK: - Test Helpers
extension MockNetworkClient {
   
   /// Sets up mock to return successful response with provided data
   func setupSuccessResponse<T: Encodable>(with object: T, delay: TimeInterval = 0.0) {
       let encoder = JSONEncoder()
       encoder.keyEncodingStrategy = .convertToSnakeCase
       
       do {
           self.dataToReturn = try encoder.encode(object)
           self.shouldReturnError = false
           self.responseDelay = delay
       } catch {
           print("Failed to encode mock data: \(error)")
       }
   }
   
   /// Sets up mock to return error response
   func setupErrorResponse(error: NetworkError, delay: TimeInterval = 0.0) {
       self.shouldReturnError = true
       self.errorToReturn = error
       self.responseDelay = delay
   }
   
   /// Resets mock to initial state
   func reset() {
       shouldReturnError = false
       errorToReturn = .invalidURL
       dataToReturn = nil
       responseDelay = 0.0
   }
}
