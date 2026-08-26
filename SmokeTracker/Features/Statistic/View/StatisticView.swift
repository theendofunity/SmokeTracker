//
//  StatisticView.swift
//  SmokeTracker
//
//  Created by ddudkin on 21.3.25..
//

import SwiftUI
import Charts

struct StatisticView: View {
    @StateObject private var viewModel = StatisticViewModel()
    
    var body: some View {
        NavigationStack {
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
            .overlay {
               
            }
            .task {
                await viewModel.load()
            }
        }
    }
}

#Preview {
    StatisticView()
}
