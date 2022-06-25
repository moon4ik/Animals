//
//  RootController.swift
//  Animals
//
//  Created by Oleksii Mykhailenko on 25.06.2022.
//

import Foundation
import UIKit

class RootController: UIViewController {
    
    private(set) var current = UIViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = UIViewController()
        vc.view.backgroundColor = .red
        transit(to: vc)
    }
    
    private func transit(to vc: UIViewController) {
        addChild(vc)
        vc.view.frame = view.bounds
        view.addSubview(vc.view)
        vc.didMove(toParent: self)
        current.willMove(toParent: nil)
        current.view.removeFromSuperview()
        current.removeFromParent()
        current = vc
    }
}
