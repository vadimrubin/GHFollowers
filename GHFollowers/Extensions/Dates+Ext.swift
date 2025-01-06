//
//  Dates+Ext.swift
//  GHFollowers
//
//  Created by Rubin Vadim on 11.12.2024.
//

import Foundation

extension Date {
    
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM YYYY"
        
        return dateFormatter.string(from: self)
    }
}
