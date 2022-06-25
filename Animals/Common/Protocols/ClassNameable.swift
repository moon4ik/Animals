//
//  ClassNameProtocol.swift
//  Animals
//
//  Created by Oleksii Mykhailenko on 25.06.2022.
//

import Foundation

protocol ClassNameable {
    
    var className: String { get }
    static var className: String { get }
}

extension ClassNameable {
    
    var className: String {
        return String(describing: type(of: self))
    }

    static var className: String {
        return String(describing: self)
    }
}
