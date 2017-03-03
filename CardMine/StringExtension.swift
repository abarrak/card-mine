//
//  StringExtension.swift
//  CardMine
//
//  Created by Abdullah on 2/28/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import Foundation

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func isBlank () -> Bool {
        return self.trim().isEmpty
    }

    // Convert a string to a proper formatted date type.
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter.date(from: self)
    }
}
