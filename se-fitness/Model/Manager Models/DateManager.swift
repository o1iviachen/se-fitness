//
//  DateManager.swift
//  se-fitness
//
//  Created by olivia chen on 2025-08-24.
//

import Foundation

// MARK: - DateManager

final class DateManager {

    // MARK: - Properties

    static let shared = DateManager()

    // MARK: - Initialization

    private init() {}

    // MARK: - Public Methods

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

    func convertToDate(dateString: String, stringFormat: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = stringFormat
        return dateFormatter.date(from: dateString)
    }
}
