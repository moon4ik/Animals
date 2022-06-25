//
//  FactModel.swift
//  Animals
//
//  Created by Oleksii Mykhailenko on 25.06.2022.
//

import Foundation

typealias Facts = [FactModel]

struct FactModel: Decodable {
    let fact: String
    let image: String
}
