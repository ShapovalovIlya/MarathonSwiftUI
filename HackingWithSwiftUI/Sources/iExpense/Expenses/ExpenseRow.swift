//
//  ExpenseRow.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 04.08.2023.
//

import SwiftUI
import Shared

struct ExpenseRow: View {
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
}

#Preview {
    ExpenseRow(expense: .sample[0])
}
