//
//  TemporaryImageCache.swift
//  CounterTCA
//
//  Created by Илья Шаповалов on 09.05.2023.
//

import Foundation
import UIKit
import SwiftUI

public protocol ImageCache {
    subscript(_ url: URL) -> UIImage? { get set }
}

public struct TemporaryImageCache: ImageCache {
    private let cache = NSCache<NSURL, UIImage>()
    
    public subscript(_ key: URL) -> UIImage? {
        get { cache.object(forKey: key as NSURL) }
        set {
            newValue == nil
            ? cache.removeObject(forKey: key as NSURL)
            : cache.setObject(newValue!, forKey: key as NSURL)
        }
    }
    
}

public struct ImageCacheKey: EnvironmentKey {
    public static let defaultValue: ImageCache = TemporaryImageCache()
}

public extension EnvironmentValues {
    var imageCache: ImageCache {
        get { self[ImageCacheKey.self] }
        set { self[ImageCacheKey.self] = newValue }
    }
}
