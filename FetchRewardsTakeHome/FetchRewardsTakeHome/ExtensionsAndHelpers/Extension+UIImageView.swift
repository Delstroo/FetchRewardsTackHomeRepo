//
//  Extension+UIImageVIew.swift
//  FetchRewardsTakeHome
//
//  Created by Delstun McCray on 4/9/23.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func downloadAndSetImage(from urlString: String, completion: (() -> Void)? = nil) {
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            completion?()
            return
        }
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion?()
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            
            if let error = error {
                print("Failed to download image: \(error.localizedDescription)")
                completion?()
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Invalid image data")
                completion?()
                return
            }
            
            imageCache.setObject(image, forKey: urlString as NSString)
            
            DispatchQueue.main.async { [weak self] in
                self?.image = image
                completion?()
            } 
        }
        
        task.resume()
    }
}
