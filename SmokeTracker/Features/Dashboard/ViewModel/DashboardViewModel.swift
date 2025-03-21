//
//  DashboardViewModel.swift
//  SmokeTracker
//
//  Created by ddudkin on 16.3.25..
//

import Foundation

final class DashboardViewModel: ObservableObject {
    enum ModelType: CaseIterable {
        case timeSinceLastSession
        case numberOfSessions
    }
    
    @Published var models: [DashboardModel] = []
    
    private let storageService = StorageService.shared
    
    init () {
        update()
    }
    
    func trackSession() {
        storageService.trackSession()
        update()
    }
}

private extension DashboardViewModel {
    func update() {
        let sessions = storageService.todaySessions()?.sessions ?? []
        
        models = makeModels(from: sessions)
    }
    
    func makeModels(from todaySessions: [SmokeSession]) -> [DashboardModel] {
        guard !todaySessions.isEmpty else {
            return []
        }
        
        return ModelType.allCases.map {
            makeModel(for: $0, sessions: todaySessions)
        }
    }
    
    func makeModel(for type: ModelType, sessions: [SmokeSession]) -> DashboardModel {
        switch type {
        case .numberOfSessions:
            return DashboardModel(
                title: "Today you\nsmoked",
                value: "\(sessions.count)",
                backgroundColor: .dashboardYellow
            )
        case .timeSinceLastSession:
            let timeSinceLast = sessions.last?.timestamp ?? Date()
            let components = Calendar.current.dateComponents([.hour, .minute], from: timeSinceLast, to: Date())
            
            let hours = components.hour ?? 0
            let minutes = components.minute ?? 0
                        
            return DashboardModel(
                title: "Last time you\nsmoked",
                value: "\(hours) hours \(minutes) minutes",
                backgroundColor: .dashboardYellow
            )
        }
    }
}
