//
//  UIView+Ext.swift
//  Animals
//
//  Created by Oleksii Mykhailenko on 26.06.2022.
//

import Foundation
import UIKit

extension UIView {
    
    func corner(radius: CGFloat) {
        self.layer.masksToBounds = radius > 0
        self.layer.cornerRadius = radius
    }
}
