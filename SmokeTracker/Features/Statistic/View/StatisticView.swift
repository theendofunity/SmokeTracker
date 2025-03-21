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
            ScrollView {
                VStack {
                    Picker("Period", selection: $viewModel.currentPeriod) {
                        ForEach(StatisticViewModel.Period.allCases, id: \.self) { period in
                            Text(period.rawValue.capitalized)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Chart {
                        BarMark(x: .value("tessrt", 123), y: .value("tessrt", 321))
                    }
                }
                .padding()
            }
            .scrollContentBackground(.hidden)
            .background(Color.mainBackground)
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.mainBackground, for: .navigationBar)
            .overlay {
                ContentUnavailableView(
                    "No data",
                    systemImage: "note.text",
                    description: .init("Track sessions to have statistics")
                )
            }
        }
    }
}

#Preview {
    StatisticView()
}
