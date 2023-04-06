//
//  MealsCollectionViewModel.swift
//  FetchRewardsTakeHome
//
//  Created by Delstun McCray on 4/5/23.
//

import Foundation
import UIKit

class MealsCollectionViewModel {
    
    static let cache = NSCache<NSString, UIImage>()

    static var mealBaseURL = "https://www.themealdb.com/api/json/v1/1/filter.php"
    static var ingredientsBaseURL = "https://www.themealdb.com/api/json/v1/1/lookup.php"
    
    static var baseURL = "https://www.themealdb.com/api/json/v1/1/filter.php"

    static func fetchMealList(idMeal: String, completion: @escaping (Result<[MealSearchResult], ErrorHandler>) -> Void) {
        guard let baseURL = URL(string: baseURL) else { return completion(.failure(.invalidURL)) }
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let mealIdCategory = URLQueryItem(name: "c", value: idMeal)
        components?.queryItems = [mealIdCategory]

        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        print("this is the \(finalURL)")

        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            if let error = error {
                return completion(.failure(.throwError(error)))
            }

            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    print("STATUS CODE: \(response.statusCode)")
                }
            }

            guard let data = data else { return completion(.failure(.noData)) }

            do {
                let topLevelObject = try JSONDecoder().decode(MealSearchResponse.self, from: data)

                var arrayOfMeals: [MealSearchResult] = []
                for strMeal in topLevelObject.meals {
                    arrayOfMeals.append(strMeal)
                }
                completion(.success(arrayOfMeals))
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.throwError(error)))
            }
        }.resume()
    } // End of func

    static func fetchMealImages(strMeal: URL, completion: @escaping (Result<UIImage, ErrorHandler>) -> Void) {
        print(baseURL)

        URLSession.shared.dataTask(with: strMeal) { data, _, error in

            if let error = error {
                return completion(.failure(.throwError(error)))
            }

            guard let data = data else { return completion(.failure(.noData)) }

            guard let imageView = UIImage(data: data) else { return completion(.failure(.unableToDecode)) }
            self.cache.setObject(imageView, forKey: NSString(string: "\(strMeal)"))
            completion(.success(imageView))

        }.resume()
    }
    
    static func fetchMealIngredients(mealID: String, completion: @escaping (Result<Meal, ErrorHandler>) -> Void) {
        guard let baseURL = URL(string: ingredientsBaseURL) else { return completion(.failure(.invalidURL)) }

        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)

        let mealIdCategory = URLQueryItem(name: "i", value: mealID)
        components?.queryItems = [mealIdCategory]

        guard let finalURL = components?.url else { return
            completion(.failure(.invalidURL))
        }
        print(finalURL)

        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            if let error = error {
                return completion(.failure(.throwError(error)))
            }

            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    print("STATUS CODE: \(response.statusCode)")
                }
            }

            guard let data = data else { return completion(.failure(.noData)) }

            do {
                let topLevelObject = try JSONDecoder().decode(MealResponse.self, from: data)

                guard let meal = topLevelObject.meals.first else { return completion(.failure(.noData)) }

                completion(.success(meal))
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.throwError(error)))
            }
        }.resume()
    }
}
