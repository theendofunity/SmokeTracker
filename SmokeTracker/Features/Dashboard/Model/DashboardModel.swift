//
//  DashboardModel.swift
//  SmokeTracker
//
//  Created by ddudkin on 16.3.25..
//

import Foundation
import SwiftUI

final class DashboardModel: Identifiable {
    let title: String
    var value: String
    let backgroundColor: Color
    
    init(title: String, value: String, backgroundColor: Color = .dashboardYellow) {
        self.title = title
        self.value = value
        self.backgroundColor = backgroundColor
    }
}

extension DashboardModel {
    static func samples() -> [DashboardModel] {
        [
            DashboardModel(title: "Last time you\nsmoked", value: "10 minutes ago"),
            DashboardModel(title: "You smoked\ntoday", value: "10 times"),
            DashboardModel(title: "You spent\ntoday", value: "10 euro")
        ]
    }
}
