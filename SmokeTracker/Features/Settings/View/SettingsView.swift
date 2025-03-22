//
//  SettingsView.swift
//  SmokeTracker
//
//  Created by ddudkin on 21.3.25..
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @State private var isAlertPresented = false
    
    private func availableCurrencies() -> [String]{
        let locales = Locale.availableIdentifiers.map { Locale(identifier: $0) }
        let currencies = [""] + locales.compactMap { $0.currency?.identifier }
        return Array(Set(currencies)).sorted()
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Price") {
                    VStack(alignment: .leading) {
                        Text("Price for package")
                        TextField("Enter price", text: $viewModel.price)
                            .keyboardType(.decimalPad)
                    }
                    Picker("Currency", selection: $viewModel.currency) {
                        ForEach(availableCurrencies(), id: \.self) { currencyCode in
                            Text("\(currencyCode)")
                                .tag(currencyCode)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section("Limits") {
                    VStack(alignment: .leading) {
                        Text("Sessions limit")
                        TextField("How many you want to smoke", text: $viewModel.sessionsLimit)
                            .keyboardType(.numberPad)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Time limit")
                        HStack {
                            TextField("How often you want to smoke", text: $viewModel.timeLimit)
                                .keyboardType(.numberPad)
                            Text("minutes")
                        }
                    }
                }
                
                Section("Data") {
                    Button("Remove data") {
                        isAlertPresented = true
                    }
                    .foregroundStyle(.red)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.mainBackground)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.mainBackground, for: .navigationBar)
            .onTapGesture {
                hideKeyboard()
            }
            .alert("Delete all data?", isPresented: $isAlertPresented) {
                Button("Delete", role: .destructive) {
                    viewModel.deleteData()
                }
                
                Button("Cancel", role: .cancel) {}
            }
        }
    }
}

#Preview {
    SettingsView()
}
