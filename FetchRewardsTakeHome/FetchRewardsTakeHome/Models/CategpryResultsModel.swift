//
//  CategpryResultsModel.swift
//  FetchRewardsTakeHome
//
//  Created by Delstun McCray on 4/5/23.
//

import Foundation

struct CategoryResults: Decodable {
    let categories: [Category]
}

struct Category: Decodable {
    let id: String
    let name: String
    let thumbnail: String
    let description: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "idCategory"
        case name = "strCategory"
        case thumbnail = "strCategoryThumb"
        case description = "strCategoryDescription"
    }
}
