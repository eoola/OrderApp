//
//  ResponseModels.swift
//  OrderApp
//
//  Created by Emmanuel Ola on 7/11/21.
//

import Foundation

struct MenuResponse: Codable {
    let items: [MenuItem]
}

struct CategoryResponse: Codable {
    let categories: [String]
}

struct OrderResponse: Codable {
    let prepTime: Int
    
    enum CodingKeys: String, CodingKey {
        case prepTime = "preparation_time"
    }
}
