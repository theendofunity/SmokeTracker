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
                
                Chart {
                    BarMark(x: .value("tessrt", 123), y: .value("tessrt", 321))
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
            .listStyle(.grouped)
            .scrollContentBackground(.hidden)
            .background(Color.mainBackground)
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.mainBackground, for: .navigationBar)
            .overlay {
               
            }
            .onAppear {
                viewModel.onAppear()
            }
        }
    }
}

#Preview {
    StatisticView()
}
