//
//  DateExtension.swift
//  CardMine
//
//  Created by Abdullah on 2/28/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import Foundation

extension Date {
    // Convert a date to a proper formatted string type.
    func toString() -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter.string(from: self)
    }
}
