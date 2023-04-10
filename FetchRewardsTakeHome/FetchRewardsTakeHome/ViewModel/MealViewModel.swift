//
//  MealViewMOdel.swift
//  FetchRewardsTakeHome
//
//  Created by Delstun McCray on 4/9/23.
//

import Foundation

class MealsViewModel {
    private var mealSearchResults: [MealSearchResult] = []
    var category: Category
    
    init(category: Category) {
        self.category = category
    }
    
    func fetchMeals(networkLayer: NetworkLayer, completion: @escaping (Result<[MealSearchResult], NetworkError>) -> Void) {
        let url = URL.apiEndpoint(url: URL.mealListURL, query: "c", queryValue: category.name)
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue

        networkLayer.fetch(request) { (result: Result<MealSearchResponse, NetworkError>) in
            switch result {
            case .success(let mealResponse):
                self.mealSearchResults = mealResponse.meals.sorted(by: { $0.name < $1.name })
                DispatchQueue.main.async {
                    completion(.success(self.mealSearchResults))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


