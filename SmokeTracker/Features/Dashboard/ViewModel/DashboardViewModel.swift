//
//  DashboardViewModel.swift
//  SmokeTracker
//
//  Created by ddudkin on 16.3.25..
//

import Foundation

final class DashboardViewModel: ObservableObject {
    @Published var models: [DashboardModel] = []
    
    private let storageService = StorageService.shared
    
    init () {
        update()
    }
    
    func trackSession() {
        storageService.trackSession()
        update()
    }
}

private extension DashboardViewModel {
    func update() {
        let data = storageService.data.first?.sessions
        models = data?.map { _ in
            DashboardModel(title: "test", value: "test")
        } ?? []
    }
}
