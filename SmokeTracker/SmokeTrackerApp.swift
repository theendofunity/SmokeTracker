//
//  SmokeTrackerApp.swift
//  SmokeTracker
//
//  Created by ddudkin on 16.3.25..
//

import SwiftUI
import SwiftData

@main
struct SmokeTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                Tab("Dashboard", systemImage: "house") {
                    DashboardView()
                }
                
                Tab("Statistic", systemImage: "list.bullet.clipboard") {
                    StatisticView()
                }
                
                Tab("Settings", systemImage: "gearshape") {
                    SettingsView()
                }
            }
            .tint(.mainAccent)
        }
    }
}
