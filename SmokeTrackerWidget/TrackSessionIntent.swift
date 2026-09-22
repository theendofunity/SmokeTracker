//
//  TrackSessionIntent.swift
//  SmokeTracker
//
//  Created by ddudkin on 22. 9. 2026..
//


import AppIntents

struct TrackSessionIntent: AppIntent {
    static let title: LocalizedStringResource = "Track session"
    static let description = IntentDescription("Adds a new smoking session with the current time.")
    static let openAppWhenRun = false

    func perform() async throws -> some IntentResult {
        StorageService.shared.trackSession()
        return .result()
    }
}
