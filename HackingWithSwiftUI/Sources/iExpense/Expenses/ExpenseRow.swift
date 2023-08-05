//
//  ExpenseRow.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 04.08.2023.
//

import SwiftUI
import Shared

struct ExpenseRow: View, Equatable {
    let expense: ExpenseItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(expense.name)
                    .font(.headline)
                Text(expense.type.rawValue)
            }
            Spacer()
            Text(expense.amount, format: .currency(code: expense.currency))
        }
    }
    
    static func == (lhs: ExpenseRow, rhs: ExpenseRow) -> Bool {
        return lhs.expense.id == rhs.expense.id
    }
}

#Preview {
    VStack {
        ExpenseRow(expense: .sample[0])
        ExpenseRow(expense: .sample[1])
        ExpenseRow(expense: .sample[2])
    }
}
