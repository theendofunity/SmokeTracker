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
    
    @AppStorage("price") var price: String = ""
    @AppStorage("currency") var currency: String = ""
    @AppStorage("sessionsLimit") var sessionsLimit: String = ""
    @AppStorage("timeLimit") var timeLimit: String = ""
    
    func deleteData() {
        price = ""
        currency = ""
        sessionsLimit = ""
        timeLimit = ""
        
        storageService.removeAll()
    }
}
