//
//  ContentView.swift
//  SmokeTracker
//
//  Created by ddudkin on 16.3.25..
//

import SwiftUI
import SwiftData

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    
    var body: some View {
        NavigationStack {
            List($viewModel.models) { $item in
                DashboardListItem(viewModel: $item)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            }
            .listStyle(.grouped)
            .background(Color.mainBackground)
            .scrollContentBackground(.hidden)
            .navigationTitle("Dashboard")
            .toolbarTitleDisplayMode(.large)
            .toolbarBackground(.mainBackground, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        viewModel.trackSession()
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .tint(Color.mainAccent)
                    }
                }
            }
            .overlay {
                if viewModel.models.isEmpty {
                    EmptyDashboardView {
                        viewModel.trackSession()
                    }
                }
            }
        }
        .onAppear {
            viewModel.update()
        }
    }
}

#Preview {
    DashboardView()
}
