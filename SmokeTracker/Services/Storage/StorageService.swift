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
    
    @Published var data = [DailySessions]()
    
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
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateKey = formatter.string(from: Date())
        
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
//        context.insert(newSession)
        
        try? context.save()
    }
    
    private func fetch() {
        let descriptor = FetchDescriptor<DailySessions>()
        data = (try? context.fetch(descriptor)) ?? []
        
        print(data.count, data.first?.sessions)
    }
    
}
