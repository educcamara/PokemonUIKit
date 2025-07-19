//
//  UIView+constraintHelpers.swift
//  PokemonUIKit
//
//  Created by Eduardo Cordeiro da Camara on 29/06/25.
//

import UIKit

extension UIView {
    
    /// Represents a set of layout edges for creating constraints.
    ///
    /// Conforms to `OptionSet` to allow for type-safe, bitmask-like combinations,
    /// such as `[.top, .bottom]` or `.all`.
    struct Edge: OptionSet, Hashable {
        let rawValue: UInt8
        
        static let top      = Edge(rawValue: 1 << 0) // 0b0001
        static let leading  = Edge(rawValue: 1 << 1) // 0b0010
        static let bottom   = Edge(rawValue: 1 << 2) // 0b0100
        static let trailing = Edge(rawValue: 1 << 3) // 0b1000
        
        static let horizontal: Edge = [.leading, .trailing]
        static let vertical: Edge   = [.top, .bottom]
        static let all: Edge        = [.horizontal, .vertical]
    }
    
    /// Activates constraints to pin the view's edges to another view's edges with uniform padding.
    ///
    /// This method simplifies the creation of common edge-anchoring constraints. It is more efficient
    /// to activate all constraints at once rather than one by one.
    ///
    /// - Parameters:
    ///   - edges: The set of edges to pin. Defaults to `.all`.
    ///   - target: The view or layout guide to pin to.
    ///   - padding: The padding for the constraints. Positive values create an inset. Defaults to `0`.
    /// - Returns: An array of the newly activated `NSLayoutConstraint` objects.
    @discardableResult
    func pin(
        edges: Edge = .all,
        to target: UILayoutGuide,
        withPadding padding: CGFloat = 0
    ) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        
        if edges.contains(.top) {
            constraints.append(topAnchor.constraint(equalTo: target.topAnchor, constant: padding))
        }
        if edges.contains(.leading) {
            constraints.append(leadingAnchor.constraint(equalTo: target.leadingAnchor, constant: padding))
        }
        if edges.contains(.bottom) {
            constraints.append(bottomAnchor.constraint(equalTo: target.bottomAnchor, constant: -padding))
        }
        if edges.contains(.trailing) {
            constraints.append(trailingAnchor.constraint(equalTo: target.trailingAnchor, constant: -padding))
        }
        
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
    
    /// Activates constraints to pin the view's edges to another view's edges with uniform padding.
    ///
    /// This is a convenience overload for pinning to another `UIView`.
    ///
    /// - Parameters:
    ///   - edges: The set of edges to pin. Defaults to `.all`.
    ///   - target: The `UIView` to pin to.
    ///   - padding: The padding for the constraints. Positive values create an inset. Defaults to `0`.
    /// - Returns: An array of the newly activated `NSLayoutConstraint` objects.
    @discardableResult
    func pin(
        edges: Edge = .all,
        to target: UIView,
        withPadding padding: CGFloat = 0
    ) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        return pin(edges: edges, to: target.safeAreaLayoutGuide, withPadding: padding)
    }
    
    /// Activates constraints to pin the view with specific padding for each edge.
    ///
    /// This method allows for different padding values for each specified edge.
    /// The dictionary keys should be singular edges (`.top`, `.leading`, etc.).
    /// Composite keys like `.all` or `.horizontal` will be ignored.
    ///
    /// - Parameters:
    ///   - edgesAndPadding: A dictionary where each key is an `Edge` and the value is its `CGFloat` padding.
    ///   - target: The view or layout guide to pin to.
    /// - Returns: An array of the newly activated `NSLayoutConstraint` objects.
    @discardableResult
    func pin(
        edgesAndPadding: [Edge: CGFloat],
        to target: UILayoutGuide
    ) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        
        for (edge, padding) in edgesAndPadding {
            if edge.contains(.top) {
                constraints.append(topAnchor.constraint(equalTo: target.topAnchor, constant: padding))
            }
            if edge.contains(.leading) {
                constraints.append(leadingAnchor.constraint(equalTo: target.leadingAnchor, constant: padding))
            }
            if edge.contains(.bottom) {
                constraints.append(bottomAnchor.constraint(equalTo: target.bottomAnchor, constant: -padding))
            }
            if edge.contains(.trailing) {
                constraints.append(trailingAnchor.constraint(equalTo: target.trailingAnchor, constant: -padding))
            }
        }
        
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
    
    /// Activates constraints to pin the view with specific padding for each edge.
    ///
    /// This is a convenience overload for pinning to another `UIView`.
    ///
    /// - Parameters:
    ///   - edgesAndPadding: A dictionary where each key is an `Edge` and the value is its `CGFloat` padding.
    ///   - target: The `UIView` to pin to.
    /// - Returns: An array of the newly activated `NSLayoutConstraint` objects.
    @discardableResult
    func pin(
        edgesAndPadding: [Edge: CGFloat],
        to target: UIView
    ) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        return pin(edgesAndPadding: edgesAndPadding, to: target.safeAreaLayoutGuide)
    }
}
