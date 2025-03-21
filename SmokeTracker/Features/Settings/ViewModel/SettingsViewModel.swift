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

    func deleteData() {
        storageService.removeAll()
        settingsService.deleteData()
    }
}
