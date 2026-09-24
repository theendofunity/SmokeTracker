//
//  UserSettingsStorage.swift
//  SmokeTracker
//
//  Created by ddudkin on 21.3.25..
//

import Foundation
import Combine
import SwiftUI

final class UserSettingsStorage: ObservableObject {    
    private enum StorageKey: String, CaseIterable {
        case price
        case currency
        case sessionsLimit
        case timeLimit
        case dayEndMinutes
        case timeSinceLast
        case todaySessions
        case todaySessionsDateKey
    }

    static let shared = UserSettingsStorage()
    static let appGroupIdentifier = "group.com.dev.dudkin.SmokeTrackerApp"
    static let appGroupDefaults: UserDefaults = {
        guard let defaults = UserDefaults(suiteName: appGroupIdentifier) else {
            fatalError("Failed to initialize App Group UserDefaults")
        }

        return defaults
    }()

    @AppStorage(StorageKey.price.rawValue, store: UserSettingsStorage.appGroupDefaults) var price: String = ""
    @AppStorage(StorageKey.currency.rawValue, store: UserSettingsStorage.appGroupDefaults) var currency: String = ""
    @AppStorage(StorageKey.sessionsLimit.rawValue, store: UserSettingsStorage.appGroupDefaults) var sessionsLimit: String = ""
    @AppStorage(StorageKey.timeLimit.rawValue, store: UserSettingsStorage.appGroupDefaults) var timeLimit: String = ""
    @AppStorage(StorageKey.dayEndMinutes.rawValue, store: UserSettingsStorage.appGroupDefaults) var dayEndMinutes: Int = 0
    @AppStorage(StorageKey.todaySessions.rawValue, store: UserSettingsStorage.appGroupDefaults) var todaySessions: Int = 0
    @AppStorage(StorageKey.todaySessionsDateKey.rawValue, store: UserSettingsStorage.appGroupDefaults) var todaySessionsDateKey: String = ""

    var timeSinceLast: Date? {
        get {
            Self.appGroupDefaults.object(forKey: StorageKey.timeSinceLast.rawValue) as? Date
        }
        set {
            if let newValue {
                Self.appGroupDefaults.set(newValue, forKey: StorageKey.timeSinceLast.rawValue)
            } else {
                Self.appGroupDefaults.removeObject(forKey: StorageKey.timeSinceLast.rawValue)
            }
        }
    }

    private init() {
        Self.migrateLegacyDefaults()
    }

    func deleteData() {
        price = ""
        currency = ""
        sessionsLimit = ""
        timeLimit = ""
        dayEndMinutes = 0
        timeSinceLast = nil
        todaySessions = 0
        todaySessionsDateKey = ""
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

    private static func migrateLegacyDefaults() {
        let legacyDefaults = UserDefaults.standard

        for key in StorageKey.allCases where appGroupDefaults.object(forKey: key.rawValue) == nil {
            guard let legacyValue = legacyDefaults.object(forKey: key.rawValue) else {
                continue
            }

            appGroupDefaults.set(legacyValue, forKey: key.rawValue)
        }
    }
}
