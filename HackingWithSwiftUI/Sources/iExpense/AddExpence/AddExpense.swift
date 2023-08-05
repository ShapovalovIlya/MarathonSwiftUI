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
    @StateObject var store: StoreOf<AddExpenseDomain> = AddExpenseDomain.previewStore
    @Environment(\.dismiss) var dismiss
    let onCommit: (ExpenseItem) -> Void
    
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
                
                HStack {
                    TextField(
                        "Amount",
                        value: Binding(
                            get: { store.amount },
                            set: { store.send(.setExpenseAmount($0)) }),
                        format: .currency(code: store.currency)
                    )
                    .keyboardType(.decimalPad)
                    .id(store.currency)
                    
                    CurrencyPicker(
                        title: "Pick currency",
                        currency: Binding(
                            get: { store.currency },
                            set: { store.send(.setCurrency($0)) }
                        )
                    )
                    .equatable()
                    .labelsHidden()
                }
            }
            .navigationTitle("Add new expense")
            .toolbar {
                Button("Save") {
                    onCommit(store.expense)
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AddExpense(
        store: AddExpenseDomain.previewStore,
        onCommit: { _ in }
    )
}
