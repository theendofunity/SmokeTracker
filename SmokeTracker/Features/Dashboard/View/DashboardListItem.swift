//
//  DashboardListItem.swift
//  SmokeTracker
//
//  Created by ddudkin on 16.3.25..
//

import SwiftUI

struct DashboardListItem: View {
    @Binding var viewModel: DashboardModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 24) {
                Text(viewModel.title)
                    .font(.title)
                    .foregroundStyle(viewModel.style.foregroundColor)
                
                Text(viewModel.value)
                    .font(.title2)
                    .foregroundStyle(viewModel.style.foregroundColor)
                    .bold()
            }
            
            Spacer()
        }
        .padding()
        .background(viewModel.style.backgroundColor)
        .clipShape(.rect(cornerRadius: 16))
    }
}

#Preview {
    @Previewable @State var  model = DashboardModel.samples().first!
    DashboardListItem(viewModel: $model)
}
