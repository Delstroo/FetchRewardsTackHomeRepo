//
//  InstructionsViewModel.swift
//  FetchRewardsTakeHome
//
//  Created by Delstun McCray on 4/9/23.
//

import UIKit

class InstructionViewModel {
    private let networkAgent = NetworkAgent()
    var meal: Meal?
    private var mealSearchResult: MealSearchResult
    private var strings: [String] = []
    
    init(mealSearchResult: MealSearchResult) {
        self.mealSearchResult = mealSearchResult
    }
    
    func fetchAllIngredients(completion: @escaping (Result<Meal, NetworkError>) -> Void) {
        let url = URL.apiEndpoint(url: URL.ingredientsURL, query: "i", queryValue: mealSearchResult.id)
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        
        NetworkAgent.shared.fetch(request) { (result: Result<MealResponse, NetworkError>) in
            switch result {
            case .success(let mealResponse):
                DispatchQueue.main.async {
                    if let meal = mealResponse.meals.first {
                        completion(.success(meal))
                    } else {
                        completion(.failure(NetworkError.noData))
                    }
                }
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
            }
        }
    }
    
    func fetchImage(completion: @escaping (Result<UIImage?, Error>) -> Void) {
        guard let meal = meal,
              let thumbnail = meal.thumbnailURL else { 
            completion(.failure(NetworkError.noData))
            return 
        }
        var request = URLRequest(url: thumbnail)
        
        let cachedImage = ImageCache.shared.loadCachedImage(forKey: thumbnail)
        
        if let cachedImage = cachedImage {
            completion(.success(cachedImage))
        } else {
            self.networkAgent.fetchImage(request) { result in
                switch result {
                case .success(let image):
                    ImageCache.shared.setImage(image, forKey: thumbnail)
                    completion(.success(image))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
