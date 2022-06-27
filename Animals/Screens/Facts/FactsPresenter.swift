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
    func share(image: UIImage?, text: String?)
    func numberOfItems() -> Int
    func viewModel(for indexPath: IndexPath) -> FactCellVM
    func select(indexPath: IndexPath)
    func prevDidTap()
    func nextDidTap()
}

class FactsPresenter: FactsPresenterProtocol {
    
    private weak var view: FactsVCProtocol!
    private let router: FactsRouterProtocol
    private let facts: Facts
    private var currentRow: Int = 0
    private var isFirst: Bool {
        return currentRow == 0
    }
    private var isLast: Bool {
        return currentRow == (facts.count-1)
    }

    
    required init(vc: FactsVCProtocol, router: FactsRouterProtocol, category: CategoryModel) {
        self.view = vc
        self.router = router
        self.view.setup(title: category.title)
        self.facts = category.content
    }
    
    func populateView() {
        view.reloadData()
        view.prevBtn(isEnabled: !isFirst)
        view.nextBtn(isEnabled: !isLast)
    }

    func numberOfItems() -> Int {
        let number = facts.count
        return number
    }
    
    func viewModel(for indexPath: IndexPath) -> FactCellVM {
        let fact = facts[indexPath.row]
        let vm = FactCellVM(imgLink: fact.image, text: fact.fact)
        return vm
    }
    
    private func checkButtons() {
        view.prevBtn(isEnabled: !isFirst)
        view.nextBtn(isEnabled: !isLast)
    }
    
    func select(indexPath: IndexPath) {
        currentRow = indexPath.row
        checkButtons()
    }
    
    func share(image: UIImage?, text: String?) {
        var items = [Any]()
        switch (image, text) {
        case (nil, nil):
            router.showInfoAlert(
                title: "Oops...",
                message: "No data to share.",
                seconds: 2
            )
            return
        default:
            if let image = image {
                items.append(image)
            }
            if let text = text {
                items.append(text)
            }
        }
        router.share(items: items)
    }
    
    func prevDidTap() {
        guard currentRow-1 >= 0 else { return }
        currentRow -= 1
        view.select(indexPath: IndexPath(row: currentRow, section: 0))
        checkButtons()
    }
    
    func nextDidTap() {
        guard facts.count > currentRow+1 else { return }
        currentRow += 1
        view.select(indexPath: IndexPath(row: currentRow, section: 0))
        checkButtons()
    }
}
