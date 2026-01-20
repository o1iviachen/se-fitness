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
    func convertToString(date: Date, stringFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = stringFormat
        return dateFormatter.string(from: date)
    }
}
