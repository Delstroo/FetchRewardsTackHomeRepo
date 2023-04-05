//
//  MealSearchModel.swift
//  FetchRewardsTakeHome
//
//  Created by Delstun McCray on 4/5/23.
//

import Foundation

struct MealSearchResponse: Decodable {
    let meals: [MealSearchResult]
}

struct MealSearchResult: Decodable {
    let name: String
    let thumbnail: String?
    let id: String
    
    private enum CodingKeys: String, CodingKey {
        case name = "strMeal"
        case thumbnail = "strMealThumb"
        case id = "idMeal"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
            name = try container.decode(String.self, forKey: .name)
            thumbnail = try? container.decodeIfPresent(String.self, forKey: .thumbnail)
            id = try container.decode(String.self, forKey: .id)
    }
}
