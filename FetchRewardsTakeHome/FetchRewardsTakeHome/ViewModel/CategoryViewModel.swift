//
//  CategoryViewModel.swift
//  FetchRewardsTakeHome
//
//  Created by Delstun McCray on 4/9/23.
//

import Foundation

import Foundation

class CategoryViewModel {
    
    // MARK: - Fetch Categories

    func fetchCategories(networkLayer: NetworkLayer, completion: @escaping (Result<[Category], NetworkError>) -> Void) {
        let url = URL.categoryURL
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue

        networkLayer.fetch(request) { (result: Result<CategoryResults, NetworkError>) in
            switch result {
            case .success(let categoryResults):
                let categories = categoryResults.categories.sorted(by: { $0.name < $1.name })
                completion(.success(categories))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

