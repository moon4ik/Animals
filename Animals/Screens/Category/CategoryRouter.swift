//
//  CategoryRouter.swift
//  Animals
//
//  Created by Oleksii Mykhailenko on 25.06.2022.
//

import Foundation
import UIKit

protocol CategoryRouterProtocol: Routable {
    func showComingSoon(message: String?)
    func showAds(category: CategoryModel)
    func showFacts(category: CategoryModel)
}

class CategoryRouter: CategoryRouterProtocol {
    
    var view: UIViewController
    
    init(vc: UIViewController) {
        view = vc
    }
    
    func showAds(category: CategoryModel) {
        let alertVC = UIAlertController(
            title: "Watch Ad to continue",
            message: nil,
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        )
        let showAdsAction = UIAlertAction(
            title: "Show Ad",
            style: .default,
            handler: { [weak self] _ in
                let adsVC = AdsScreenBuilder.build()
                self?.present(modal: adsVC, style: .overFullScreen)
                let hideAds = DispatchWorkItem {
                    adsVC.dismiss(animated: true)
                    let vc = FactsScreenBuilder.build(category: category)
                    self?.push(vc: vc)
                }
                DispatchQueue.main.asyncAfter(
                    deadline: .now() + .seconds(2),
                    execute: hideAds
                )
            }
        )
        alertVC.addAction(cancelAction)
        alertVC.addAction(showAdsAction)
        present(vc: alertVC)
    }
    
    func showFacts(category: CategoryModel) {
        let vc = FactsScreenBuilder.build(category: category)
        push(vc: vc)
    }
    
    func showComingSoon(message: String?) {
        let alertVC = UIAlertController(
            title: "Coming soon",
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: "OK",
            style: .cancel,
            handler: nil
        )
        alertVC.addAction(okAction)
        present(vc: alertVC)
    }
}
