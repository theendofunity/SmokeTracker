//
//  HistoryCellView.swift
//  SmokeTracker
//
//  Created by ddudkin on 26. 8. 2026..
//

import SwiftUI

struct HistoryCellView: View {
    let model: HistoryCellViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(model.date)
                .font(.title)
            Text("\(model.count) cigarettes")
                .font(.subheadline)
        }
    }
}

#Preview {
    HistoryCellView(model: .init(date: "today", spent: 123, count: 20))
}
