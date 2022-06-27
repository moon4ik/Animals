//
//  AppError.swift
//  Animals
//
//  Created by Oleksii Mykhailenko on 25.06.2022.
//

import Foundation

enum AppError: Error {
    case invalidURL
    case invalidImage
    case cancelled
    case with(message: String)
}
