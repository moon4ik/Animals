//
//  UIImageView+Ext.swift
//  Animals
//
//  Created by Oleksii Mykhailenko on 25.06.2022.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadImage(url urlString: String) {
        self.image = nil
        guard let url = URL(string: urlString) else { return }
        if let cachedImage = imageCache.object(forKey: urlString as NSString)  {
            self.image = cachedImage
            return
        }
        let indicator = UIActivityIndicatorView(style: .medium)
        addSubview(indicator)
        indicator.startAnimating()
        indicator.center = self.center
        let dataTask = URLSession.shared.dataTask(
            with: url,
            completionHandler: { [weak self] (data, _, error) in
                guard error == nil, let data = data, let image = UIImage(data: data) else {
                    DispatchQueue.main.async {
                        indicator.removeFromSuperview()
                    }
                    return
                }
                DispatchQueue.main.async {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self?.image = image
                    indicator.removeFromSuperview()
                }
            }
        )
        dataTask.resume()
    }
}
