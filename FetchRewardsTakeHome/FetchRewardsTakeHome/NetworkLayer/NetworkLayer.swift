//
//  NetworkLayer.swift
//  FetchRewardsTakeHome
//
//  Created by Delstun McCray on 4/5/23.
//

import Foundation
import UIKit

struct NetworkAgent {
    func fetch<T: Codable>(_ request: URLRequest, completion: @escaping (Result<T, ErrorHandler>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(ErrorHandler.throwError(error)))
                return
            }
            
            guard let data = data, !data.isEmpty else {
                completion(.failure(ErrorHandler.noData))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(ErrorHandler.noData))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                _ = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                completion(.failure(ErrorHandler.throwError(error!)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(T.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(ErrorHandler.throwError(error)))
                return
            }
        }.resume()
    }
}
