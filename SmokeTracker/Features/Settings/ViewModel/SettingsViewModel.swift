//
//  SettingsViewModel.swift
//  SmokeTracker
//
//  Created by ddudkin on 21.3.25..
//

import Foundation
import SwiftUI

final class SettingsViewModel: ObservableObject {
    private let storageService = StorageService.shared
    private let settingsService = UserSettingsStorage.shared

    var price: String {
        get {
            settingsService.price
        }

        set {
            settingsService.price = newValue
        }
    }
    
    var currency: String {
        get {
            settingsService.currency
        }
        
        set {
            settingsService.currency = newValue
        }
    }
    
    var sessionsLimit: String {
        get {
            settingsService.sessionsLimit
        }
        
        set {
            settingsService.sessionsLimit = newValue
        }
    }
    
    var timeLimit: String {
        get {
            settingsService.timeLimit
        }
        
        set {
            settingsService.timeLimit = newValue
        }
    }

    var dayEnd: Date {
        get {
            let minutes = settingsService.dayEndMinutes
            return Calendar.current.date(
                bySettingHour: minutes / 60,
                minute: minutes % 60,
                second: 0,
                of: Date()
            ) ?? Date()
        }

        set {
            let components = Calendar.current.dateComponents([.hour, .minute], from: newValue)
            settingsService.dayEndMinutes = (components.hour ?? 0) * 60 + (components.minute ?? 0)
        }
    }

    func deleteData() {
        storageService.removeAll()
        settingsService.deleteData()
    }
}
