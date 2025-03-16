//
//  DashboardViewModel.swift
//  SmokeTracker
//
//  Created by ddudkin on 16.3.25..
//

import Foundation

final class DashboardViewModel: ObservableObject {
    @Published var models: [DashboardModel] = []
    
    init () {
        models = DashboardModel.samples()
    }
}
