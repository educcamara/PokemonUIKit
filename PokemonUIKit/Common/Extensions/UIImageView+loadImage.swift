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
    ///   - completion: Optional completion when image fetch from cache or download completes
    func loadImage(
        urlString: String,
        placeholder: UIImage? = nil,
        completion: ((Result<UIImage, Error>) -> Void)? = nil
    ) {
        cancelImageLoading()

        // Tries to get from cache
        let cacheKey = urlString as NSString
        if let cachedImage = getCachedImage(for: cacheKey) {
            setImage(cachedImage)
            completion?(.success(cachedImage))
            return
        }
        
        // Fetches from URL
        setImage(placeholder)
        downloadImage(from: urlString, cacheKey: cacheKey, completion: completion)
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
    
    func downloadImage(
        from urlString: String,
        cacheKey: NSString,
        completion: ((Result<UIImage, Error>) -> Void)?
    ) {
        guard let url = URL(string: urlString) else {
            completion?(.failure(NetworkError.invalidURL))
            return
        }
        
        let request = URLRequest(url: url)
        currentTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self else { return }
            currentTask = nil
            
            if let error {
                logger.warning("Image loading error: \(error.localizedDescription)")
                completion?(.failure(NetworkError.custom(error)))
                return
            }
            
            guard let data,
                  let image = UIImage(data: data) else {
                logger.warning("Invalid image data received")
                completion?(.failure(NetworkError.custom(URLError(URLError.cannotDecodeRawData))))
                return
            }
            
            cacheImage(image, for: cacheKey)
            setImage(image)
            completion?(.success(image))
        }
        
        currentTask?.resume()
    }
}

//MARK: - Logger
import os.log

private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "UIImageView+loadImage")
