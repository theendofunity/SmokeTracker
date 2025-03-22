//
//  DashboardViewModel.swift
//  SmokeTracker
//
//  Created by ddudkin on 16.3.25..
//

import Foundation
import SwiftUI

final class DashboardViewModel: ObservableObject {
    enum ModelType: CaseIterable {
        case timeSinceLastSession
        case numberOfSessions
        case price
    }
    
    @Published var models: [DashboardModel] = []
    
    private let storageService = StorageService.shared
    private let settingsService = UserSettingsStorage.shared

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
    
    func update() {
        let sessions = storageService.todaySessions()?.sessions ?? []
        
        models = makeModels(from: sessions)
    }
}

private extension DashboardViewModel {
    func makeModels(from todaySessions: [SmokeSession]) -> [DashboardModel] {
        guard !todaySessions.isEmpty else {
            return []
        }
        
        return ModelType.allCases.compactMap {
            makeModel(for: $0, sessions: todaySessions)
        }
    }
    
    func makeModel(for type: ModelType, sessions: [SmokeSession]) -> DashboardModel? {
        var style = DashboardModel.Style.green
        
        switch type {
        case .numberOfSessions:
            if let limit = Int(settingsService.sessionsLimit) {
                if sessions.count > limit {
                    style = .red
                } else if sessions.count >= limit - 5 {
                    style = .yellow
                }
            }
            
            return DashboardModel(
                title: "Today you\nsmoked",
                value: "\(sessions.count) times",
                style: style
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
            
            if let limit = Int(settingsService.timeLimit) {
                let value = minutes + hours * 60
                
                if value < limit - 10 {
                    style = .red
                } else if value < limit {
                    style = .yellow
                }
            }
                        
            return DashboardModel(
                title: "Last time you\nsmoked",
                value: dateString,
                style: style
            )
            
        case .price:
            let price = settingsService.price
            guard !price.isEmpty else {
                return nil
            }
            
            let value = (Double(price) ?? 0) * Double(sessions.count) / 20
            let formattedValue = String(format: "%.2f", value)
            
            return DashboardModel(
                title: "You spent\ntoday",
                value: "\(formattedValue) \(settingsService.currency)",
                style: style
            )
        }
    }
    
    func runTimer() {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true , block: { [weak self] _ in
            self?.update()
        })
    }
}
