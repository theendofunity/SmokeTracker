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
    private let settingsService: UserSettingsStorage
    
    @Published var currentPeriod: Period = .week
    @Published var history: [HistoryCellViewModel]
    
    init(
        storageService: StorageService = .shared,
        settingsService: UserSettingsStorage = .shared
    ) {
        self.storageService = storageService
        self.settingsService = settingsService
        history = Self.makeHistory(
            from: storageService.allSessions,
            dayEndMinutes: settingsService.dayEndMinutes
        )
    }
    
    func onAppear() {
        history = Self.makeHistory(
            from: storageService.allSessions,
            dayEndMinutes: settingsService.dayEndMinutes
        )
    }
}

private extension StatisticViewModel {
    static func makeHistory(
        from sessions: [DailySessions],
        dayEndMinutes: Int
    ) -> [HistoryCellViewModel] {
        let sessionsByDay = Dictionary(grouping: sessions.flatMap(\.sessions)) { session in
            UserSettingsStorage.dateKey(
                for: session.timestamp,
                dayEndMinutes: dayEndMinutes
            )
        }

        return sessionsByDay.map { date, sessions in
            .init(date: date, spent: 0.0, count: sessions.count)
        }
        .sorted { $0.date > $1.date }
    }
}
