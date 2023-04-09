//
//  URLExtensions.swift
//  FetchRewardsTakeHome
//
//  Created by Delstun McCray on 4/9/23.
//

import Foundation

extension URL {
    static var categoryURL: URL {
        return URL(string: "https://www.themealdb.com/api/json/v1/1/categories.php")!
    }
    
    static var mealListURL: URL {
        return URL(string: "https://themealdb.com/api/json/v1/1/filter.php")!
    }
    
    static var ingredientsURL: URL {
        return URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php")!
    }
    
    static func apiEndpoint(url: URL, query: String? = nil ,queryValue: String? = nil) -> URL {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = [URLQueryItem(name: query ?? "", value: queryValue ?? "")]
        return components?.url ?? url
    }
}
