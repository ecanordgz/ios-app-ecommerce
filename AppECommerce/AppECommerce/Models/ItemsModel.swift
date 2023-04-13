//
//  ItemsModel.swift
//  AppECommerce
//
//  Created by Enrique Cano on 13/04/23.
//

import Foundation

struct ItemsModel: Codable {
    
    var image: String? = nil
    var name: String? = nil
    var price: Int? = nil
    
    enum CodingKeys: String, CodingKey {
      case image = "image"
      case name = "name"
      case price = "price"
    }

    init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      image = try values.decodeIfPresent(String.self, forKey: .image)
      name = try values.decodeIfPresent(String.self, forKey: .name)
      price = try values.decodeIfPresent(Int.self, forKey: .price)
      
    }

    init() {}
}
