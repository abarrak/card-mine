//
//  UITextViewExtension.swift
//  CardMine
//
//  Created by Abdullah on 4/20/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import UIKit

extension UITextView {
    // source: http://stackoverflow.com/a/38855122
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
}
