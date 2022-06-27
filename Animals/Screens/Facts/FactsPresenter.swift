//
//  FactsPresenter.swift
//  Animals
//
//  Created by Oleksii Mykhailenko on 26.06.2022.
//

import Foundation
import UIKit

protocol FactsPresenterProtocol: AnyObject {
    func populateView()
    func share(image: UIImage?, text: String)
    func prevDidTap()
    func nextDidTap()
}

class FactsPresenter: FactsPresenterProtocol {
    
    private weak var view: FactsVCProtocol!
    private let router: FactsRouterProtocol
    private let facts: Facts
    private var current: Int = 0
    private var isFirst: Bool {
        return current == 0
    }
    private var isLast: Bool {
        return current == (facts.count-1)
    }
    
    required init(vc: FactsVCProtocol, router: FactsRouterProtocol, category: CategoryModel) {
        self.view = vc
        self.router = router
        self.view.setup(title: category.title)
        self.facts = category.content
    }
    
    func populateView() {
        guard let first = facts.first else {
            router.showInfoAlert(
                title: "Attention",
                message: "Something goes wrong",
                seconds: 3
            )
            return
        }
        let vm = FactVM(
            imgURL: first.image,
            text: first.fact,
            isFirst: isFirst,
            isLast: isLast
        )
        view.setup(vm: vm)
    }
    
    func prevDidTap() {
        guard current-1 >= 0 else { return }
        current -= 1
        let fact = facts[current]
        setupView(fact: fact)
    }
    
    func nextDidTap() {
        guard facts.count > current+1 else { return }
        current += 1
        let fact = facts[current]
        setupView(fact: fact)
    }
    
    private func setupView(fact: FactModel) {
        let vm = FactVM(
            imgURL: fact.image,
            text: fact.fact,
            isFirst: isFirst,
            isLast: isLast
        )
        view.setup(vm: vm)
    }
    
    func share(image: UIImage?, text: String) {
        var items = [Any]()
        if let image = image {
            items.append(image)
        }
        items.append(text)
        router.share(items: items)
    }
}
