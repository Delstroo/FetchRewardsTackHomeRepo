//
//  NetworkLayer.swift
//  FetchRewardsTakeHome
//
//  Created by Delstun McCray on 4/5/23.
//

import Foundation
import UIKit

struct NetworkAgent {
    func fetch<T: Codable>(_ request: URLRequest, completion: @escaping (Result<T, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(NetworkError.throwError(error)))
                return
            }
            
            guard let data = data, !data.isEmpty else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                _ = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                completion(.failure(NetworkError.throwError(error!)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(T.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(NetworkError.throwError(error)))
                return
            }
        }.resume()
    }
    
    func fetchImage(_ request: URLRequest, cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(NetworkError.throwError(error)))
                return
            }
            
            guard let data = data, !data.isEmpty else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                _ = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                completion(.failure(NetworkError.throwError(error!)))
                return
            }
            if let image = UIImage(data: data) {
                guard let url = request.url else { return }
                ImageCache.shared.setImage(image, forKey: url)
                completion(.success(image))
            } else {
                completion(.failure(.noData))
            }
        }.resume()
    }
}
