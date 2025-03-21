//
//  EmptyDashboardView.swift
//  SmokeTracker
//
//  Created by ddudkin on 20.3.25..
//

import SwiftUI

struct EmptyDashboardView: View {
    var addAction: () -> Void
    
    var body: some View {
        ContentUnavailableView {
            VStack(spacing: 24) {
                Text("Track your first\nsmoking session")
                Button("Track") {
                    addAction()
                }
                .foregroundStyle(.white)
                .buttonStyle(.bordered)
                .background(.mainAccent)
                .clipShape(.rect(cornerRadius: 8))
            }
        }
    }
}

#Preview {
    EmptyDashboardView {
        
    }
}
