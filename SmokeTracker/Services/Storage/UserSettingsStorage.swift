//
//  UserSettingsStorage.swift
//  SmokeTracker
//
//  Created by ddudkin on 21.3.25..
//

import Foundation
import SwiftUI

final class UserSettingsStorage: ObservableObject {
    static let shared = UserSettingsStorage()
        
    @AppStorage("price") var price: String = ""
    @AppStorage("currency") var currency: String = ""
    @AppStorage("sessionsLimit") var sessionsLimit: String = ""
    @AppStorage("timeLimit") var timeLimit: String = ""
    @AppStorage("dayEndMinutes") var dayEndMinutes: Int = 0

    private init() {}

    func deleteData() {
        price = ""
        currency = ""
        sessionsLimit = ""
        timeLimit = ""
        dayEndMinutes = 0
    }

    func dateKey(for date: Date = Date()) -> String {
        Self.dateKey(for: date, dayEndMinutes: dayEndMinutes)
    }

    static func dateKey(
        for date: Date,
        dayEndMinutes: Int,
        calendar: Calendar = .current
    ) -> String {
        var boundaryComponents = calendar.dateComponents([.year, .month, .day], from: date)
        boundaryComponents.hour = dayEndMinutes / 60
        boundaryComponents.minute = dayEndMinutes % 60
        boundaryComponents.second = 0

        let boundary = calendar.date(from: boundaryComponents) ?? calendar.startOfDay(for: date)
        let logicalDate: Date

        if date < boundary {
            logicalDate = calendar.date(byAdding: .day, value: -1, to: date) ?? date
        } else {
            logicalDate = date
        }

        let components = calendar.dateComponents([.year, .month, .day], from: logicalDate)
        return String(
            format: "%04d-%02d-%02d",
            components.year ?? 0,
            components.month ?? 0,
            components.day ?? 0
        )
    }
}
