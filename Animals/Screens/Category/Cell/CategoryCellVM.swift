//
//  CategoryCellVM.swift
//  Animals
//
//  Created by Oleksii Mykhailenko on 25.06.2022.
//

import Foundation
import UIKit

struct CategoryCellVM {
    let imageURL: String
    let title: String
    let subtitle: String
    let status: CategoryStatus
    let paidImage: UIImage?
    let paidTitle: String?
    let comingSoonImage: UIImage?
    let overlayColor: UIColor?
}
