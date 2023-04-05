//
//  MealResponseModel.swift
//  FetchRewardsTakeHome
//
//  Created by Delstun McCray on 4/5/23.
//

import Foundation

struct MealResponse: Decodable {
    let meals: [Meal]
}

struct Ingredients: Decodable {
    let name: String
    let measurement: String
}

struct Meal: Decodable {
    let id: String
    let name: String
    let category: String
    let area: String
    let instructions: String
    let thumbnailURL: URL?
    let youtubeURL: URL?
    let sourceURL: URL?
    let ingredients: [Ingredients]

    private enum PrimaryCodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case category = "strCategory"
        case instructions = "strInstructions"
        case thumbnailURL = "strMealThumb"
        case youtubeURL = "strYoutube"
        case sourceURL = "strSource"
        case area = "strArea"
    }

    struct DynamicCodingKey: CodingKey {
        var intValue: Int?
        var stringValue = ""

        init?(intValue: Int) {
            self.intValue = intValue
        }

        init?(stringValue: String) {
            self.stringValue = stringValue
        }
    } // End of struct

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PrimaryCodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        category = try container.decode(String.self, forKey: .category)
        area = try container.decode(String.self, forKey: .area)
        instructions = try container.decode(String.self, forKey: .instructions)
        thumbnailURL = try? container.decode(URL.self, forKey: .thumbnailURL)
        youtubeURL = try? container.decodeIfPresent(URL.self, forKey: .youtubeURL)
        sourceURL = try? container.decodeIfPresent(URL.self, forKey: .sourceURL)

        let dynamic = try decoder.container(keyedBy: DynamicCodingKey.self)
        var ingredients: [Ingredients] = []

        for i in 1 ... 20 {
            if let nameKey = DynamicCodingKey(stringValue: "strIngredient\(i)"),
               let measurementKey = DynamicCodingKey(stringValue: "strMeasure\(i)"),
               let name = try dynamic.decodeIfPresent(String.self, forKey: nameKey),
               let measurement = try dynamic.decodeIfPresent(String.self, forKey: measurementKey),
               !name.isEmpty,
               !measurement.isEmpty {
                ingredients.append(Ingredients(name: name, measurement: measurement))
            }
        }
        self.ingredients = ingredients
    }
}
