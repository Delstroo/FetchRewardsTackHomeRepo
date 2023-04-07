//
//  ImageCache.swift
//  FetchRewardsTakeHome
//
//  Created by Delstun McCray on 4/5/23.
//

import Foundation
import UIKit

class ImageCache {
    static let shared = ImageCache()

    let cache = NSCache<NSURL, UIImage>()

    private init() {}

    func setImage(_ image: UIImage, forKey key: URL) {
        cache.setObject(image, forKey: key as NSURL)
    }

    func loadCachedImage(forKey key: URL) -> UIImage? {
        return cache.object(forKey: key as NSURL)
    }
}
