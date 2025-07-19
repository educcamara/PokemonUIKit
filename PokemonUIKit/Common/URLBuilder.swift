//
//  Untitled.swift
//  PokemonUIKit
//
//  Created by Eduardo Cordeiro da Camara on 19/07/25.
//

import Foundation

public class URLBuilder {
    
    // MARK: - Properties
    
    private var scheme: String?
    private var domain: String?
    private var paths: [String] = []
    private var queries: [URLQueryItem] = []
    
    // MARK: - Initializer
    
    public init() {}
    
    // MARK: - Builder Methods
    
    @discardableResult
    public func httpsScheme() -> URLBuilder {
        self.scheme = "https"
        return self
    }
    
    @discardableResult
    public func httpScheme() -> URLBuilder {
        self.scheme = "http"
        return self
    }
    
    @discardableResult
    public func scheme(_ scheme: String) -> URLBuilder {
        self.scheme = scheme
        return self
    }
    
    @discardableResult
    public func domain(_ domain: String) -> URLBuilder {
        self.domain = domain
        return self
    }
    
    @discardableResult
    public func appendingPath(_ path: String) -> URLBuilder {
        self.paths.append(path)
        return self
    }
    
    @discardableResult
    public func appendingQuery(key: String, value: String) -> URLBuilder {
        self.queries.append(URLQueryItem(name: key, value: value))
        return self
    }
    
    // MARK: - Build Method
    
    public func build() -> URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = domain
        components.path = "/" + paths.joined(separator: "/")
        components.queryItems = queries.isEmpty ? nil : queries
        
        return components.url
    }
}
