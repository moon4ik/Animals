//
//  Routable.swift
//  Animals
//
//  Created by Oleksii Mykhailenko on 25.06.2022.
//

import Foundation
import UIKit

protocol Routable: AnyObject {
    var view: UIViewController { get set }
    func push(vc: UIViewController)
    func present(vc: UIViewController)
    func present(modal vc: UIViewController, style: UIModalPresentationStyle)
    func showInfoAlert(title: String?, message: String?, seconds: Int)
}

extension Routable {

    func push(vc: UIViewController) {
        DispatchQueue.main.async {
            self.view.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func present(vc: UIViewController) {
        DispatchQueue.main.async {
            self.view.present(vc, animated: true)
        }
    }
    
    func present(modal vc: UIViewController, style: UIModalPresentationStyle) {
        DispatchQueue.main.async {
            vc.modalPresentationStyle = style
            self.view.present(vc, animated: true)
        }
    }
    
    func showInfoAlert(title: String?, message: String?, seconds: Int) {
        let alertVC = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .actionSheet
        )
        DispatchQueue.main.async {
            self.view.present(alertVC, animated: true) {
                DispatchQueue.main.asyncAfter(
                    deadline: .now() + .seconds(seconds),
                    execute: {
                        alertVC.dismiss(animated: true)
                    }
                )
            }
        }
    }
    
}
