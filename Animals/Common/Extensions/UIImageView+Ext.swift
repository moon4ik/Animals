//
//  UIImageView+Ext.swift
//  Animals
//
//  Created by Oleksii Mykhailenko on 25.06.2022.
//

import Foundation
import UIKit

extension UIImageView {
        
    func loadFrom(link urlString: String) {
        self.image = nil
        guard let url = URL(string: urlString) else { return }
        // indicator
        let indicator = UIActivityIndicatorView(style: .medium)
        addSubview(indicator)
        indicator.color = .appBg
        indicator.startAnimating()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        // download
        let cachePolicy: URLRequest.CachePolicy = url.pathExtension.isEmpty ? .reloadRevalidatingCacheData : .returnCacheDataElseLoad
        let request = URLRequest(
            url: url,
            cachePolicy: cachePolicy,
            timeoutInterval: 15
        )
        let dataTask = URLSession.shared.dataTask(
            with: request,
            completionHandler: { [weak self] (data, response, error) in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                else {
                    DispatchQueue.main.async {
                        self?.image = .placeholder
                        indicator.removeFromSuperview()
                    }
                    return
                }
                DispatchQueue.main.async {
                    self?.image = image
                    indicator.removeFromSuperview()
                }
            }
        )
        dataTask.resume()
    }
}
