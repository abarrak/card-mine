//
//  UIActivityIndicatorViewExtension.swift
//  CardMine
//
//  Created by Abdullah on 4/21/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import UIKit
import CoreGraphics

extension UIActivityIndicatorView {
    // source: http://stackoverflow.com/a/42937631
    func scale(factor: CGFloat) {
        guard factor > 0.0 else { return }
        
        transform = CGAffineTransform(scaleX: factor, y: factor)
    }
}
