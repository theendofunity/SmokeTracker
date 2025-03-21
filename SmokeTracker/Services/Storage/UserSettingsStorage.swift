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
    
    private init() {}
    
    func deleteData() {
        price = ""
        currency = ""
        sessionsLimit = ""
        timeLimit = ""
    }
}
