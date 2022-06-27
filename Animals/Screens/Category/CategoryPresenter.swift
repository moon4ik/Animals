//
//  CategoryPresenter.swift
//  Animals
//
//  Created by Oleksii Mykhailenko on 25.06.2022.
//

import Foundation
import UIKit

protocol CategoryPresenterProtocol {
    func fetchCategories()
    func numberOfRows() -> Int
    func didSelectRow(at indexPath: IndexPath)
    func heightForRow(at indexPath: IndexPath) -> CGFloat
    func getCellVM(for indexPath: IndexPath) -> CategoryCellVM?
}

class CategoryPresenter: CategoryPresenterProtocol {
    
    private weak var view: CategoryVCProtocol!
    private let router: CategoryRouterProtocol
    private let dataSource: DataSourceProtocol
    
    private var categories = Categories()
    
    required init(vc: CategoryVCProtocol, router: CategoryRouterProtocol, dataSource: DataSourceProtocol) {
        self.view = vc
        self.router = router
        self.dataSource = dataSource
    }
    
    func fetchCategories() {
        DispatchQueue.main.async {
            self.view.showLoading()
        }
        let result = dataSource.loadData()
        switch result {
        case .success(let categories):
            self.categories = categories
            self.categories.sort()
            DispatchQueue.main.async {
                self.view.hideLoading()
                self.view.update()
            }
        case .failure(let error):
            DispatchQueue.main.async {
                self.view.hideLoading()
                self.router.showInfoAlert(
                    title: "Attention",
                    message: error.localizedDescription,
                    seconds: 2
                )
            }
        }
    }
    
    func numberOfRows() -> Int {
        let count = categories.count
        return count
    }
    
    func heightForRow(at indexPath: IndexPath) -> CGFloat {
        let height: CGFloat = 116
        return height
    }
    
    func getCellVM(for indexPath: IndexPath) -> CategoryCellVM? {
        let category = categories[indexPath.row]
        let status = category.status
        let isPaid = (status == .paid)
        let paidImage: UIImage? = isPaid ? .lockIcon : nil
        let paidTitle: String? = isPaid ? "Premium" : nil
        let isComingSoon = (status == .comingSoon)
        let comingSoonImage: UIImage? = isComingSoon ? .comingSoonIcon : nil
        let overlayColor: UIColor? = isComingSoon ? UIColor.black.withAlphaComponent(0.6) : nil
        let vm = CategoryCellVM(
            imageURL: category.image,
            title: category.title,
            subtitle: category.desc,
            status: status,
            paidImage: paidImage,
            paidTitle: paidTitle,
            comingSoonImage: comingSoonImage,
            overlayColor: overlayColor
        )
        return vm
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        let category = categories[indexPath.row]
        let isFactsPresent = category.content.count > 0
        switch category.status {
        case .free:
            if isFactsPresent {
                router.showFacts(category: category)
            } else {
                router.showInfoAlert(
                    title: "Oops...",
                    message: "We don't know any facts about \(category.title)",
                    seconds: 2
                )
            }
        case .paid:
            if isFactsPresent {
                router.showAds(category: category)
            } else {
                router.showInfoAlert(
                    title: "Oops...",
                    message: "We don't know any facts about \(category.title)",
                    seconds: 2
                )
            }
        case .comingSoon:
            router.showComingSoon(message: category.title)
        }
    }
}
