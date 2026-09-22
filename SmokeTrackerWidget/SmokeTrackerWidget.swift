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
            lastSessionTimestamp: nil
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetEntry) -> ()) {
        completion(context.isPreview ? placeholder(in: context) : makeEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let now = Date.now
        let startOfCurrentMinute = Calendar.current.dateInterval(of: .minute, for: now)?.start ?? now
        let lastSessionTimestamp = userStorage.timeSinceLast
        let entries = (0...60).map { minuteOffset in
            let date = minuteOffset == 0
                ? now
                : startOfCurrentMinute.addingTimeInterval(TimeInterval(minuteOffset * 60))

            return WidgetEntry(
                date: date,
                lastSessionTimestamp: lastSessionTimestamp
            )
        }

        completion(Timeline(entries: entries, policy: .atEnd))
    }

    private func makeEntry() -> WidgetEntry {
        WidgetEntry(date: .now, lastSessionTimestamp: userStorage.timeSinceLast)
    }
}

struct WidgetEntry: TimelineEntry {
    let date: Date
    let lastSessionTimestamp: Date?
}

struct SmokeTrackerWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            Text("Last session")
            
            if let lastSession = entry.lastSessionTimestamp {
                Text(elapsedTime(since: lastSession))
                    .font(.title2.bold())
                    .monospacedDigit()
                    .minimumScaleFactor(0.7)
            } else {
                Text("No sessions")
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            HStack {
                Spacer()
                
                Button(intent: TrackSessionIntent()) {
                    Label("Track", systemImage: "plus.circle")
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
    }
}

#Preview(as: .systemSmall) {
    SmokeTrackerWidget()
} timeline: {
    WidgetEntry(
        date: .now,
        lastSessionTimestamp: nil
    )
}
