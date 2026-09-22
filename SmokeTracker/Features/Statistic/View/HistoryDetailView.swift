//
//  HistoryDetailView.swift
//  SmokeTracker
//
//  Created by ddudkin on 22. 9. 2026..
//

import SwiftUI

struct HistoryDetailView: View {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject var viewModel: HistoryDetailViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.cells) { model in
                Text(model.dateString)
            }
            .onDelete { index in
                viewModel.delete(item: index)
            }
        }
        .navigationTitle(viewModel.date)
        .onAppear {
            viewModel.onAppear()
        }
        .onChange(of: scenePhase) { _, newPhase in
            guard newPhase == .active else {
                return
            }

            viewModel.onAppear()
        }
    }
}

#Preview {
    HistoryDetailView(viewModel: .init(date: UserSettingsStorage.shared.dateKey()))
}
