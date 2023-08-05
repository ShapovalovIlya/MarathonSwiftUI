//
//  ExpensesList.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 05.08.2023.
//

import SwiftUI
import Shared

struct ExpensesList: View {
    let expenses: [ExpenseItem]
    let removeAction: (ExpenseItem) -> Void
    
    var body: some View {
        ForEach(expenses) { expense in
            ExpenseRow(expense: expense)
                .equatable()
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        removeAction(expense)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
                .listRowBackground(background(for: expense))
        }
    }
    
    private func background(for expense: ExpenseItem) -> Color {
        switch expense.amount {
        case ..<10:
            return .green
            
        case ..<100:
            return .yellow
            
        case 100...:
            return .red
            
        default:
            return .white
        }
    }

}

#Preview {
    ExpensesList(
        expenses: ExpenseItem.sample,
        removeAction: { _ in }
    )
}
