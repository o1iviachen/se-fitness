//
//  DateManager.swift
//  se-fitness
//
//  Created by olivia chen on 2025-08-24.
//

import Foundation

struct DateManager {
    func todayAtMidnight() -> Date {
        let today = Date()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: today)
        return startOfDay
    }
    func convertToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        return dateFormatter.string(from: date)
    }
}
