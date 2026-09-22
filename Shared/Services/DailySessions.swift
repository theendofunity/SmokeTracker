//
//  Item.swift
//  SmokeTracker
//
//  Created by ddudkin on 16.3.25..
//

import Foundation
import SwiftData

@Model
final class DailySessions {
    @Attribute(.unique) var dateString: String  // "yyyy-MM-dd" format, unique
    var sessions: [SmokeSession] = []
    
    init(dateString: String) {
        self.dateString = dateString
    }
}

@Model
final class SmokeSession {
    var timestamp: Date
    var title: String = ""
  
    init(
        timestamp: Date,
        title: String
    ) {
        self.timestamp = timestamp
        self.title = title
    }
}
