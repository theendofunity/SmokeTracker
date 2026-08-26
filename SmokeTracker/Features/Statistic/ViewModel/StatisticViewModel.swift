//
//  StatisticViewModel.swift
//  SmokeTracker
//
//  Created by ddudkin on 21.3.25..
//

import Foundation

final class StatisticViewModel: ObservableObject {
    enum Period: String, CaseIterable {
        case week
        case month
        case year
    }
    
    private let storageService: StorageService
    
    @Published var currentPeriod: Period = .week
    @Published var history: [HistoryCellViewModel]
    
    init(storageService: StorageService = .shared) {
        self.storageService = storageService
        history = Self.makeHistory(from: storageService.allSessions)
    }
    
    func onAppear() {
        history = Self.makeHistory(from: storageService.allSessions)
    }
}

private extension StatisticViewModel {
    static func makeHistory(from sessions: [DailySessions]) -> [HistoryCellViewModel] {
        sessions.map({
            .init(date: $0.dateString, spent: 0.0, count: $0.sessions.count)
        })
    }
}
