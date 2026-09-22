//
//  StorageService.swift
//  SmokeTracker
//
//  Created by ddudkin on 20.3.25..
//

import Foundation
import SwiftData

final class StorageService: ObservableObject {
    static var shared = StorageService()
    
    private let container: ModelContainer
    private let context: ModelContext
    private let settingsService = UserSettingsStorage.shared
    
    private(set)var allSessions = [DailySessions]()
    
    private init() {
        let schema = Schema([DailySessions.self, SmokeSession.self])
        let container = try? ModelContainer(for: schema, migrationPlan: .none)

        guard let container else {
            fatalError("Failed to initialize ModelContainer")
        }
        
        self.container = container
        context = ModelContext(container)
        fetch()
    }
    
    func trackSession(at timestamp: Date = Date()) {
        let dateKey = settingsService.dateKey(for: timestamp)
        
        let fetchDescriptor = FetchDescriptor<DailySessions>(predicate: #Predicate { $0.dateString == dateKey })

        let currentSession: DailySessions
        
        if let existingSession = try? context.fetch(fetchDescriptor).first {
            currentSession = existingSession
        } else {
            currentSession = DailySessions(dateString: dateKey)
            context.insert(currentSession)
        }
        
        let newSession = SmokeSession(timestamp: timestamp, title: "")
        currentSession.sessions.append(newSession)
        
        try? context.save()
        fetch()
    }
    
    func todaySessions() -> [SmokeSession] {
        let dateKey = settingsService.dateKey()

        return allSessions.flatMap(\.sessions).filter { session in
            settingsService.dateKey(for: session.timestamp) == dateKey
        }
    }
    
    func sessions(for date: String) -> [SmokeSession] {
        return allSessions.flatMap(\.sessions).filter { session in
            settingsService.dateKey(for: session.timestamp) == date
        }
    }
    
    func sessionTimestamps() async -> [Date] {
        let container = container

        return await Task.detached(priority: .utility) {
            let context = ModelContext(container)
            let descriptor = FetchDescriptor<SmokeSession>()
            let sessions = (try? context.fetch(descriptor)) ?? []
            return sessions.map(\.timestamp)
        }.value
    }

    func removeAll() {
        do {
            try context.delete(model: DailySessions.self)
            try context.delete(model: SmokeSession.self)
            try context.save()
            fetch()
        } catch {
            context.rollback()
            fetch()
            print(error)
        }

    }
    
    func remove(sessions: [SmokeSession]) throws {
        do {
            for session in sessions {
                if let dailySessions = allSessions.first(where: { dailySessions in
                    dailySessions.sessions.contains(where: { $0 === session })
                }) {
                    dailySessions.sessions.removeAll(where: { $0 === session })

                    if dailySessions.sessions.isEmpty {
                        context.delete(dailySessions)
                    }
                }

                context.delete(session)
            }

            try context.save()
            fetch()
        } catch {
            context.rollback()
            fetch()
            throw error
        }
    }
}

private extension StorageService {
    func fetch() {
        let descriptor = FetchDescriptor<DailySessions>()
        allSessions = (try? context.fetch(descriptor)) ?? []
    }
}
