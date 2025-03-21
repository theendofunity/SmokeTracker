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
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            DailySessions.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            DashboardView()
        }
        .modelContainer(sharedModelContainer)
    }
}
