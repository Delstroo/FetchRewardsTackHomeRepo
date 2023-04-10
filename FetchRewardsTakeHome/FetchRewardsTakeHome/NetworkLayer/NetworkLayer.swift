//
//  NetworkLayer.swift
//  FetchRewardsTakeHome
//
//  Created by Delstun McCray on 4/5/23.
//

import Foundation
import UIKit

enum NetworkError: LocalizedError {
    case invalidURL
    case throwError(Error)
    case noData
    case unableToDecode(Error)

    var errorDescription: String {
        switch self {
        case .invalidURL:
            return "There was a failure with the server."
        case .throwError:
            return "there was an error with our network call."
        case .noData:
            return "There was no data found."
        case .unableToDecode:
            return "there was no data found."
        }
    }
}

class NetworkLayer {
    
    static let shared = NetworkLayer()
    
    func fetch<T: Codable>(_ request: URLRequest, completion: @escaping (Result<T, NetworkError>) -> Void) {
            if let cachedResponse = URLCache.shared.cachedResponse(for: request) {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(T.self, from: cachedResponse.data)
                    completion(.success(response))
                } catch {
                    completion(.failure(NetworkError.throwError(error)))
                }
                return
            }
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(self.generateNetworkError(from: error)))
                    return
                }
                
                guard let data = data, !data.isEmpty,
                      let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(NetworkError.noData))
                    return
                }
                
                if let httpResponse = response {
                    let cachedResponse = CachedURLResponse(response: httpResponse, data: data)
                    URLCache.shared.storeCachedResponse(cachedResponse, for: request)
                }
                
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(T.self, from: data)
                    completion(.success(response))
                } catch {
                    completion(.failure(NetworkError.throwError(error)))
                }
            }.resume()
        }
    
    private func generateNetworkError(from error: Error?) -> NetworkError {
        if let error = error {
            if let urlError = error as? URLError {
                return NetworkError.throwError(urlError)
            } else if let decodingError = error as? DecodingError {
                return NetworkError.unableToDecode(decodingError)
            }
        }
        return NetworkError.noData
    }
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    // Add more cases for other HTTP methods as needed
}
