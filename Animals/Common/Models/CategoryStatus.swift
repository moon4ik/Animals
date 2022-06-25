//
//  CategoryStatus.swift
//  Animals
//
//  Created by Oleksii Mykhailenko on 25.06.2022.
//

import Foundation

public enum CategoryStatus: String {
    case free
    case paid
    case comingSoon

    init(raw: String) {
        switch raw.lowercased() {
        case "free":
            self = .free
        case "paid":
            self = .paid
        default:
            self = .comingSoon
        }
    }
}
