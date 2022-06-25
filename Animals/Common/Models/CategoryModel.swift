//
//  CategoryModel.swift
//  Animals
//
//  Created by Oleksii Mykhailenko on 25.06.2022.
//

import Foundation

typealias Categories = [CategoryModel]

struct CategoryModel: Decodable, Comparable {
    
    let title: String
    let desc: String
    let image: String
    let order: Int
    let status: CategoryStatus
    let content: Facts
    
    enum CodingKeys: String, CodingKey {
        case title
        case desc = "description"
        case image
        case order
        case status
        case content
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        desc = try values.decode(String.self, forKey: .desc)
        image = try values.decode(String.self, forKey: .image)
        order = try values.decode(Int.self, forKey: .order)
        let decodeStatus = try values.decode(String.self, forKey: .status)
        status = CategoryStatus(raw: decodeStatus)
        let facts = try? values.decode(Facts?.self, forKey: .content)
        content = facts ?? []
    }
    
    static func < (lhs: CategoryModel, rhs: CategoryModel) -> Bool {
        lhs.order < rhs.order
    }
    
    static func == (lhs: CategoryModel, rhs: CategoryModel) -> Bool {
        lhs.order == rhs.order
    }
}
