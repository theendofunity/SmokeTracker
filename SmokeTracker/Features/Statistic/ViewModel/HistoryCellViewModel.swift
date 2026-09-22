//
//  HistoryCellViewModel.swift
//  SmokeTracker
//
//  Created by ddudkin on 26. 8. 2026..
//

import Foundation

final class HistoryCellViewModel: Identifiable {
    let id: String
    let date: String
    let spent: Double
    let count: Int
    
    var action: EmptyClosure?
    
    init(date: String, spent: Double, count: Int, action: EmptyClosure?) {
        self.id = date
        self.date = date
        self.spent = spent
        self.count = count
        self.action = action
    }
}
