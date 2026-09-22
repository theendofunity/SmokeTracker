//
//  StatisticView.swift
//  SmokeTracker
//
//  Created by ddudkin on 21.3.25..
//

import SwiftUI
import Charts

struct StatisticView: View {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var viewModel = StatisticViewModel()
    
    var body: some View {
        NavigationStack(path: $viewModel.routes) {
            List {
                Picker("Period", selection: $viewModel.currentPeriod) {
                    ForEach(StatisticViewModel.Period.allCases, id: \.self) { period in
                        Text(period.rawValue.capitalized)
                    }
                }
                .pickerStyle(.segmented)
                
                if viewModel.isLoading && viewModel.history.isEmpty {
                    HStack {
                        Spacer()
                        ProgressView("Loading statistics…")
                        Spacer()
                    }
                    .frame(height: 200)
                    .listRowSeparator(.hidden)
                } else {
                    Chart(viewModel.history) { model in
                        BarMark(
                            x: .value("Date", model.date),
                            y: .value("Cigarettes", model.count)
                        )
                        .foregroundStyle(Color.mainAccent)
                    }
                    .chartXAxis {
                        AxisMarks(values: .automatic(desiredCount: 6)) { value in
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel {
                                if let date = value.as(String.self) {
                                    Text(compactDate(date))
                                }
                            }
                        }
                    }
                    .frame(height: 200)

                    if viewModel.history.isEmpty {
                        ContentUnavailableView(
                            "No data",
                            systemImage: "note.text",
                            description: .init("Track sessions to have statistics")
                        )
                    } else {
                        ForEach(viewModel.history) { model in
                            HistoryCellView(model: model)
                        }
                    }
                }
            }
            .listStyle(.grouped)
            .scrollContentBackground(.hidden)
            .background(Color.mainBackground)
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.mainBackground, for: .navigationBar)
            .task(id: scenePhase) {
                guard scenePhase == .active else {
                    return
                }

                await viewModel.load()
            }
            .navigationDestination(for: StatisticViewModel.Route.self) { route in
                switch route {
                case let .details(date):
                    HistoryDetailView(viewModel: .init(date: date))
                }
            }
        }
    }

    private func compactDate(_ date: String) -> String {
        guard let value = Self.dateFormatter.date(from: date) else {
            return date
        }

        return value.formatted(.dateTime.day().month(.abbreviated))
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

#Preview {
    StatisticView()
}
