//
//  AddExpense.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 03.08.2023.
//

import SwiftUI
import SwiftUDF
import Shared

struct AddExpense: View {
    @ObservedObject var store: StoreOf<ExpensesDomain>
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                TextField(
                    "Name",
                    text: Binding(
                        get: { store.name },
                        set: { store.send(.setExpenseName($0)) })
                )
                
                Picker(
                    "Type",
                    selection: Binding(
                        get: { store.type },
                        set: { store.send(.setExpenseType($0)) })
                ) {
                    ForEach(ExpenseItem.ExpenseType.allCases, id: \.self) { type in
                        Text(type.rawValue)
                    }
                }
                
                TextField(
                    "Amount",
                    value: Binding(
                        get: { store.amount },
                        set: { store.send(.setExpenseAmount($0)) }),
                    format: .currency(code: "USD")
                )
                .keyboardType(.decimalPad)
            }
            .navigationTitle("Add new expense")
            .toolbar {
                Button("Save") {
                    store.send(.saveButtonTap)
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AddExpense(store: ExpensesDomain.previewStore)
}
