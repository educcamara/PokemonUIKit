//
//  UIImageView+LoadImage.swift
//  PokemonUIKit
//
//  Created by Eduardo Cordeiro da Camara on 27/06/25.
//

import Foundation
import UIKit
import ObjectiveC.runtime

// MARK: - Associated Object Keys
private var taskKey: UInt8 = 0

// MARK: - UIImageView Extension
extension UIImageView {
    
    // MARK: - Private Properties
    
    private static let imageCache = NSCache<NSString, UIImage>()
    
    private var currentTask: URLSessionDataTask? {
        get {
            objc_getAssociatedObject(self, &taskKey) as? URLSessionDataTask
        }
        set {
            objc_setAssociatedObject(self, &taskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // MARK: - Public Methods
    
    /// Loads an image from a URL string with caching support
    /// - Parameters:
    ///   - urlString: The URL string of the image to load
    ///   - placeholder: Optional placeholder image to show while loading
    func loadImage(urlString: String, placeholder: UIImage? = nil) {
        cancelImageLoading()
        
        guard let url = URL(string: urlString) else {
            setImage(placeholder)
            return
        }
        
        let cacheKey = urlString as NSString
        
        if let cachedImage = getCachedImage(for: cacheKey) {
            setImage(cachedImage)
            return
        }
        
        setImage(placeholder)
        startImageDownload(from: url, cacheKey: cacheKey)
    }
    
    /// Cancels any ongoing image loading task
    func cancelImageLoading() {
        currentTask?.cancel()
        currentTask = nil
    }
}

// MARK: - Private Methods
private extension UIImageView {
    func getCachedImage(for key: NSString) -> UIImage? {
        return UIImageView.imageCache.object(forKey: key)
    }
    
    func cacheImage(_ image: UIImage, for key: NSString) {
        UIImageView.imageCache.setObject(image, forKey: key)
    }
    
    func setImage(_ image: UIImage?) {
        if Thread.isMainThread {
            self.image = image
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.image = image
            }
        }
    }
    
    func startImageDownload(from url: URL, cacheKey: NSString) {
        let request = URLRequest(url: url)
        
        currentTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            self.handleImageDownloadResponse(
                data: data,
                response: response,
                error: error,
                cacheKey: cacheKey
            )
        }
        
        currentTask?.resume()
    }
    
    func handleImageDownloadResponse(
        data: Data?,
        response: URLResponse?,
        error: Error?,
        cacheKey: NSString
    ) {
        // Clear the current task since it's completed
        currentTask = nil
        
        // Check for errors
        if let error = error {
            print("Image loading error: \(error.localizedDescription)")
            return
        }
        
        // Validate and process the image data
        guard let data = data,
              let image = UIImage(data: data) else {
            print("Invalid image data received")
            return
        }
        
        // Cache the image
        cacheImage(image, for: cacheKey)
        
        // Update UI on main thread
        setImage(image)
    }
}
