//
//  CategoryScreenBuilder.swift
//  Animals
//
//  Created by Oleksii Mykhailenko on 25.06.2022.
//

import Foundation
import UIKit

class CategoryScreenBuilder {
    
    static func build() -> UIViewController {
        let vc = CategoryVC()
        let router = CategoryRouter(vc: vc)
        let url = Bundle.main.url(forResource: "ios-challenge-words-booster", withExtension: "json")
        let source = DataSource(url: url)
        let presenter = CategoryPresenter(vc: vc, router: router, dataSource: source)
        vc.presenter = presenter
        return vc
    }
    
}
