//
//  FactsRouter.swift
//  Animals
//
//  Created by Oleksii Mykhailenko on 26.06.2022.
//

import Foundation
import UIKit

protocol FactsRouterProtocol: Routable {
    func share(items: [Any])
}

class FactsRouter: FactsRouterProtocol {
    
    var view: UIViewController
    
    init(vc: UIViewController) {
        view = vc
    }
    
    func share(items: [Any]) {
        let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(vc: vc)
    }
}
