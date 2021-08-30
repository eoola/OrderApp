//
//  Order.swift
//  OrderApp
//
//  Created by Emmanuel Ola on 7/11/21.
//

import Foundation

struct Order: Codable {
    var menuItems: [MenuItem]
    
    init(menuItems: [MenuItem] = []) {
        self.menuItems = menuItems
    }
}
