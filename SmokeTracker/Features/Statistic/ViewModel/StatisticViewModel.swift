//
//  StatisticViewModel.swift
//  SmokeTracker
//
//  Created by ddudkin on 21.3.25..
//

import Foundation

final class StatisticViewModel: ObservableObject {
    enum Period: String, CaseIterable {
        case week
        case month
        case year
    }
    
    private let storageService = StorageService.shared
    
    @Published var currentPeriod: Period = .week
}
