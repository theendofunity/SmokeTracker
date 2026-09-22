//
//  HistoryDetailViewModel.swift
//  SmokeTracker
//
//  Created by ddudkin on 22. 9. 2026..
//

import Foundation

final class HistoryDetailViewModel: ObservableObject {
    private let storage = StorageService.shared
    
    final class CellViewModel: Identifiable {
        let id: UUID
        let dateString: String
        let session: SmokeSession
        
        init(date: Date, session: SmokeSession) {
            self.id = UUID()
            self.session = session
            
            let formatter = DateFormatter()
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            
            self.dateString = formatter.string(from: date)
        }
    }
    
    let date: String
    
    @Published var cells: [CellViewModel] = []
    
    init(date: String) {
        self.date = date
    }
    
    func onAppear() {
        load()
    }
    
    func delete(item: IndexSet) {
        let sessions = item.compactMap { index in
            cells.indices.contains(index) ? cells[index].session : nil
        }

        guard sessions.count == item.count else {
            return
        }

        do {
            try storage.remove(sessions: sessions)
            cells.remove(atOffsets: item)
        } catch {
            print(error)
        }
    }
    
    private func load() {
        let sessions = storage.sessions(for: date)
            .sorted { lhs, rhs in
                lhs.timestamp > rhs.timestamp
            }
        
        cells = sessions.map({ session in
            return .init(date: session.timestamp, session: session)
        })
    }
}
