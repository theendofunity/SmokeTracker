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
    
    private let context: ModelContext
    
    private var allSessions = [DailySessions]()
    
    private init() {
        let schema = Schema([DailySessions.self, SmokeSession.self])
        let container = try? ModelContainer(for: schema, migrationPlan: .none)
        
        guard let container else {
            fatalError("Failed to initialize ModelContainer")
        }
        
        context = ModelContext(container)
        fetch()
    }
    
    func trackSession() {
        let dateKey = todayDateString()
        
        let fetchDescriptor = FetchDescriptor<DailySessions>(predicate: #Predicate { $0.dateString == dateKey })

        let currentSession: DailySessions
        
        if let existingSession = try? context.fetch(fetchDescriptor).first {
            currentSession = existingSession
        } else {
            currentSession = DailySessions(dateString: dateKey)
            context.insert(currentSession)
        }
        
        let newSession = SmokeSession(timestamp: Date(), title: "")
        currentSession.sessions.append(newSession)
        
        try? context.save()
    }
    
    func todaySessions() -> DailySessions? {
        return allSessions.first { session in
            session.dateString == todayDateString()
        }
    }
}

private extension StorageService {
    func todayDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter.string(from: Date())
    }
    
    func fetch() {
        let descriptor = FetchDescriptor<DailySessions>()
        allSessions = (try? context.fetch(descriptor)) ?? []
    }
}
