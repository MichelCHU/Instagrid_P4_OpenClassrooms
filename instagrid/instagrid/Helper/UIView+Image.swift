//
//  UIView+Image.swift
//  instagrid
//
//  Created by Square on 22/07/2021.
//

import UIKit

extension UIView {
    var image: UIImage {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        return renderer.image { _ in drawHierarchy(in: bounds, afterScreenUpdates: true) }
    }
}
