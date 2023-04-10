//
//  InstructionsViewModel.swift
//  FetchRewardsTakeHome
//
//  Created by Delstun McCray on 4/9/23.
//

import UIKit

class InstructionViewModel {
    private let networkAgent = NetworkLayer()
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
        
        NetworkLayer.shared.fetch(request) { (result: Result<MealResponse, NetworkError>) in
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
}
