//
//  CategoryResultsModel.swift
//  FetchRewardsTakeHome
//
//  Created by Delstun McCray on 4/5/23.
//

import Foundation
import UIKit

class CategoryCollectionViewModel {
    static let cache = NSCache<NSString, UIImage>()

    static var baseURL = "https://www.themealdb.com/api/json/v1/1/categories.php"

    static func fetchCategoryList(completion: @escaping (Result<[Category], ErrorHandler>) -> Void) {
        guard let baseURL = URL(string: baseURL) else { return completion(.failure(.invalidURL)) }

        let components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)

        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        print(finalURL)

        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            if let error = error {
                return completion(.failure(.throwError(error)))
            }

            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    print("STATUS CODE: \(response.statusCode)")
                }

                guard let data = data else { return completion(.failure(.noData)) }

                do {
                    let topLevelObject = try JSONDecoder().decode(CategoryResults.self, from: data)

                    var arrayOfMeals: [Category] = []
                    for strCategory in topLevelObject.categories {
                        arrayOfMeals.append(strCategory)
                    }
                    completion(.success(arrayOfMeals))
                } catch {
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    return completion(.failure(.throwError(error)))
                }
            }
        }.resume()
    }

    static func fetchCategoryImages(
        strCategoryThumb: String,
        completion: @escaping (Result<UIImage, ErrorHandler>) -> Void) {
        guard let baseURL = URL(string: "\(strCategoryThumb)") else { return completion(.failure(.invalidURL)) }

        URLSession.shared.dataTask(with: baseURL) { data, _, error in

            if let error = error {
                return completion(.failure(.throwError(error)))
            }

            guard let data = data else { return completion(.failure(.noData)) }

            guard let imageView = UIImage(data: data) else { return completion(.failure(.unableToDecode)) }
            self.cache.setObject(imageView, forKey: NSString(string: strCategoryThumb))
            completion(.success(imageView))

        }.resume()
    }
}
