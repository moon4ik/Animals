//
//  ImageService.swift
//  Animals
//
//  Created by Oleksii Mykhailenko on 26.06.2022.
//

import Foundation
import UIKit

class ImageLoader {
    
    @discardableResult
    func loadFrom(link urlString: String, completion: @escaping (Result<UIImage, AppError>)->Void) -> URLSessionDataTask? {
        guard
            let url = URL(string: urlString)
        else {
            completion(.failure(.invalidURL))
            return nil
        }
        let cachePolicy: URLRequest.CachePolicy = url.pathExtension.isEmpty ? .reloadRevalidatingCacheData : .returnCacheDataElseLoad
        let request = URLRequest(
            url: url,
            cachePolicy: cachePolicy,
            timeoutInterval: 15
        )
        let dataTask = URLSession.shared.dataTask(
            with: request,
            completionHandler: { (data, response, error) in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                else {
                    if error?.localizedDescription == "cancelled" {
                        completion(.failure(.cancelled))
                    } else {
                        completion(.failure(.invalidImage))
                    }
                    return
                }
                completion(.success(image))
            }
        )
        dataTask.resume()
        return dataTask
    }
}
