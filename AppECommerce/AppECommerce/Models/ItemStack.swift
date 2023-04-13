//
//  ItemStack.swift
//  AppECommerce
//
//  Created by Enrique Cano on 13/04/23.
//

import Foundation

struct ItemStack: Codable {
    var items: [ItemsModel]? = []
    var layoutEnum: String?  = nil

    enum CodingKeys: String, CodingKey {
      case items = "items"
      case layoutEnum = "layoutEnum"
    
    }

    init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      items = try values.decodeIfPresent([ItemsModel].self , forKey: .items)
      layoutEnum = try values.decodeIfPresent(String.self  , forKey: .layoutEnum)
    }

    init() {}
}
