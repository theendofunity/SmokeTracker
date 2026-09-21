//
//  StatisticViewModel.swift
//  SmokeTracker
//
//  Created by ddudkin on 21.3.25..
//

import Foundation

@MainActor
final class StatisticViewModel: ObservableObject {
    enum Period: String, CaseIterable {
        case week
        case month
        case year
    }
    
    private let storageService = StorageService.shared
    private let settingsService = UserSettingsStorage.shared
    
    @Published var currentPeriod: Period = .week {
        didSet {
            Task {
                await load()
            }
        }
    }
    
    @Published private(set) var history: [HistoryCellViewModel] = []
    @Published private(set) var isLoading = true

    func load() async {
        let dayEndMinutes = settingsService.dayEndMinutes
        isLoading = history.isEmpty

        try? await Task.sleep(for: .milliseconds(250))
        guard !Task.isCancelled else { return }

        let timestamps = await storageService.sessionTimestamps()
            .filter { date in
                var threshold: Date?
                
                switch currentPeriod {
                case .week:
                    threshold = Calendar.current.date(byAdding: .day, value: -7, to: Date())
                case .month:
                    threshold = Calendar.current.date(byAdding: .day, value: -30, to: Date())
                case .year:
                    threshold = Calendar.current.date(byAdding: .day, value: -365, to: Date())
                }
                
                guard let threshold else {
                    return true
                }
                
                return date > threshold
            }
        
        guard !Task.isCancelled else { return }

        let summaries = await Task.detached(priority: .utility) {
            Self.makeHistory(
                from: timestamps,
                dayEndMinutes: dayEndMinutes
            )
        }.value
        guard !Task.isCancelled else { return }

        history = summaries.map {
            .init(date: $0.date, spent: 0.0, count: $0.count)
        }
        isLoading = false
    }
}

private extension StatisticViewModel {
    struct HistorySummary: Sendable {
        let date: String
        let count: Int
    }

    nonisolated static func makeHistory(
        from timestamps: [Date],
        dayEndMinutes: Int
    ) -> [HistorySummary] {
        let sessionsByDay = Dictionary(grouping: timestamps) { timestamp in
            UserSettingsStorage.dateKey(
                for: timestamp,
                dayEndMinutes: dayEndMinutes
            )
        }

        return sessionsByDay.map { date, sessions in
            .init(date: date, count: sessions.count)
        }
        .sorted { $0.date > $1.date }
    }
}
