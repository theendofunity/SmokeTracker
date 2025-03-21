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
    private var timer: Timer?
    
    init () {
        update()
        runTimer()
    }
    
    func trackSession() {
        storageService.trackSession()
        update()
        runTimer()
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
                value: "\(sessions.count) times",
                backgroundColor: .dashboardYellow
            )
            
        case .timeSinceLastSession:
            let timeSinceLast = sessions.sorted { lhs, rhs in
                rhs.timestamp > lhs.timestamp
            }.last?.timestamp ?? Date()
            
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
                        
            return DashboardModel(
                title: "Last time you\nsmoked",
                value: dateString,
                backgroundColor: .dashboardYellow
            )
        }
    }
    
    func runTimer() {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true , block: { [weak self] _ in
            print("timer")
            self?.update()
        })
    }
}
