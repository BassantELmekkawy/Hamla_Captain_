//
//  Date.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 13/07/2024.
//

import Foundation

extension Date {
    func isToday() -> Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    func isYesterday() -> Bool {
        return Calendar.current.isDateInYesterday(self)
    }
    
    func isDateInWeek() -> Bool {
        let calendar = Calendar.current
        guard let weekAgo = calendar.date(byAdding: .day, value: -6, to: Date()) else {
            return false
        }
        return self > weekAgo
    }
    
    func formattedString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        if isToday() {
            formatter.dateFormat = "h:mm a"
            return "Today \(formatter.string(from: self))"
        } else if isYesterday() {
            formatter.dateFormat = "h:mm a"
            return "Yesterday \(formatter.string(from: self))"
        } else if isDateInWeek() {
            formatter.dateFormat = "E h:mm a"
            return formatter.string(from: self)
        } else {
            formatter.dateFormat = "d MMMM h:mm a"
            return formatter.string(from: self)
        }
    }
}

extension DateFormatter {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a dd/MM/yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
