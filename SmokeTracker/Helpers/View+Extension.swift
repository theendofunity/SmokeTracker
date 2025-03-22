//
//  View+Extension.swift
//  SmokeTracker
//
//  Created by ddudkin on 22.3.25..
//

import Foundation
import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
