//
//  DateFormatting.swift
//  SmokeTracker
//
//  Created by ddudkin on 22. 9. 2026..
//

import Foundation

final class DateFormatting {
    struct FormatingResult {
        let dateString: String
        let timeValue: Int
        
        init(dateString: String, minutes: Int, hours: Int) {
            self.dateString = dateString
            self.timeValue = minutes + hours * 60
        }
    }
    static func timeSinceLast(_ timeSinceLast: Date) -> FormatingResult {
        let components = Calendar.current.dateComponents([.hour, .minute], from: timeSinceLast, to: Date())
        
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        
        let dateString: String
        
        if hours == 0, minutes == 0 {
            dateString = "Now"
        } else if hours == 0 {
            dateString = "\(minutes) minutes ago"
        } else {
            dateString = "\(hours) hours \(minutes) minutes ago"
        }
        
        return .init(dateString: dateString, minutes: minutes, hours: hours)
    }
}
