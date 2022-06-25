//
//  DataSource.swift
//  Animals
//
//  Created by Oleksii Mykhailenko on 25.06.2022.
//

import Foundation

protocol DataSourceProtocol {
    func loadData() -> Result<Categories, AppError>
}

final class DataSource: DataSourceProtocol {
    
    private let url: URL?
    
    init(url: URL?) {
        self.url = url
    }
    
    func loadData() -> Result<Categories, AppError> {
        guard let url = url else {
            return .failure(.invalidURL)
        }
        do {
            let data = try Data(contentsOf: url)
            let categories = try decode(Categories.self, from: data)
            return .success(categories)
        } catch {
            let err = AppError.with(message: error.localizedDescription)
            return .failure(err)
        }
    }
    
    //MARK: -
    
    private func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(T.self, from: data)
            return result
        } catch {
            let err = AppError.with(message: error.localizedDescription)
            throw err
        }
    }
}
