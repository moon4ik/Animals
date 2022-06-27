//
//  FactsScreenBuilder.swift
//  Animals
//
//  Created by Oleksii Mykhailenko on 26.06.2022.
//

import Foundation
import UIKit

class FactsScreenBuilder {
    
    static func build(category: CategoryModel) -> UIViewController {
        let vc = FactsVC()
        let router = FactsRouter(vc: vc)
        let presenter = FactsPresenter(vc: vc, router: router, category: category)
        vc.presenter = presenter
        return vc
    }
}
