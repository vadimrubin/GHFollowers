//
//  String+Ext.swift
//  GHFollowers
//
//  Created by Rubin Vadim on 11.12.2024.
//

import Foundation

extension String {
    //этот extension больше не используем, но сохраняем его в проекте, т.к. может быть очень полезным 
    
    func convertToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = .current
        
        return dateFormatter.date(from: self)
    }
    
    func convertToDisplayFormat() -> String {
        guard let date = self.convertToDate() else { return "N/A" }
        return date.convertToMonthYearFormat()
    }
}
