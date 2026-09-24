//
//  SmokeTrackerWidget.swift
//  SmokeTrackerWidget
//
//  Created by ddudkin on 22. 9. 2026..
//

import WidgetKit
import SwiftUI
import AppIntents

struct Provider: TimelineProvider {
    private let userStorage = UserSettingsStorage.shared

    func placeholder(in context: Context) -> WidgetEntry {
        WidgetEntry(
            date: .now,
            lastSessionTimestamp: nil,
            numberOfSessions: 0
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetEntry) -> ()) {
        completion(context.isPreview ? placeholder(in: context) : makeEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let now = Date.now
        let startOfCurrentMinute = Calendar.current.dateInterval(of: .minute, for: now)?.start ?? now
        let lastSessionTimestamp = userStorage.timeSinceLast
        let storedSessionsCount = userStorage.todaySessions
        let sessionsDateKey = userStorage.todaySessionsDateKey
        let entries = (0...60).map { minuteOffset in
            let date = minuteOffset == 0
                ? now
                : startOfCurrentMinute.addingTimeInterval(TimeInterval(minuteOffset * 60))

            return WidgetEntry(
                date: date,
                lastSessionTimestamp: lastSessionTimestamp,
                numberOfSessions: userStorage.dateKey(for: date) == sessionsDateKey
                    ? storedSessionsCount
                    : 0
            )
        }

        completion(Timeline(entries: entries, policy: .atEnd))
    }

    private func makeEntry() -> WidgetEntry {
        let date = Date.now

        return WidgetEntry(
            date: date,
            lastSessionTimestamp: userStorage.timeSinceLast,
            numberOfSessions: userStorage.dateKey(for: date) == userStorage.todaySessionsDateKey
                ? userStorage.todaySessions
                : 0
        )
    }
}

struct WidgetEntry: TimelineEntry {
    let date: Date
    let lastSessionTimestamp: Date?
    let numberOfSessions: Int
}

struct SmokeTrackerWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            Text("Last session")

            if let lastSession = entry.lastSessionTimestamp {
                HStack {
                    Text(elapsedTime(since: lastSession))
                        .font(.title2.bold())
                        .monospacedDigit()
                        .minimumScaleFactor(0.7)
                    
                    Text("ago")
                }
            } else {
                Text("No sessions")
                    .foregroundStyle(.secondary)
            }
            
            Text("Today")
            Text("\(entry.numberOfSessions) times")
                .font(.title2.bold())
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            
            Spacer()
            
            HStack {
                Spacer()
                
                Button(intent: TrackSessionIntent()) {
                    Label("Track", systemImage: "plus.circle")
                        .frame(maxWidth: .infinity)
                }
                
                Spacer()
            }
        }
    }

    private func elapsedTime(since lastSession: Date) -> String {
        let totalMinutes = max(0, Int(entry.date.timeIntervalSince(lastSession) / 60))
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60

        return String(format: "%02d:%02d", hours, minutes)
    }
}

struct SmokeTrackerWidget: Widget {
    let kind = SmokeTrackerWidgetConfiguration.kind

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                SmokeTrackerWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                SmokeTrackerWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    SmokeTrackerWidget()
} timeline: {
    WidgetEntry(
        date: .now,
        lastSessionTimestamp: nil,
        numberOfSessions: 0
    )
}
