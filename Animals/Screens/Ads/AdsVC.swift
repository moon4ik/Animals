//
//  AdsVC.swift
//  Animals
//
//  Created by Oleksii Mykhailenko on 26.06.2022.
//

import Foundation
import UIKit

class AdsVC: UIViewController {
    
    private let adsLabel = UILabel()
    private let indicator = UIActivityIndicatorView(style: .medium)
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
    }
    
    private func setupView() {
        view.addSubview(blurView)
        view.addSubview(indicator)
        view.addSubview(adsLabel)
        indicator.color = .white
        indicator.startAnimating()
        adsLabel.text = "Animals Ads"
        adsLabel.textColor = .white
        adsLabel.textAlignment = .center
        adsLabel.font = .systemFont(ofSize: 40, weight: .ultraLight)
    }
    
    private func setupLayout() {
        blurView.translatesAutoresizingMaskIntoConstraints = false
        indicator.translatesAutoresizingMaskIntoConstraints = false
        adsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            adsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            adsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50)
        ])
    }
}
