//
//  DashboardModel.swift
//  SmokeTracker
//
//  Created by ddudkin on 16.3.25..
//

import Foundation
import SwiftUI

final class DashboardModel: Identifiable {
    enum Style {
        case red
        case yellow
        case green
        
        var backgroundColor: Color {
            switch self {
            case .red:
                return .dashboardRed
            case .yellow:
                return .dashboardYellow
            case .green:
                return .mainAccent
            }
        }
        
        var foregroundColor: Color {
            switch self {
            case .red:
                return  .white
            case .yellow:
                return  .black
            case .green:
                return   .white
            }
        }
    }
    
    let title: String
    var value: String
    let style: Style
    
    init(title: String, value: String, style: Style = .green) {
        self.title = title
        self.value = value
        self.style = style
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
