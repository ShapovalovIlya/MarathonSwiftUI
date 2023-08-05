//
//  iExpenseView.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 03.08.2023.
//

import SwiftUI
import SwiftUDF
import Shared

struct ExpensesList: View {
    let expenses: [ExpenseItem]
    let removeAction: (ExpenseItem) -> Void
    
    var body: some View {
        ForEach(expenses) { expense in
            ExpenseRow(expense: expense)
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        removeAction(expense)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
        }
    }
}

public struct iExpenseView: View {
    @StateObject var store: StoreOf<ExpensesDomain>
    
    //MARK: - body
    public var body: some View {
        List {
            Section("Personal") {
                ExpensesList(
                    expenses: store.personalExpenses,
                    removeAction: { store.send(.removeExpense($0)) }
                )
            }
            Section("Business") {
                ExpensesList(
                    expenses: store.businessExpenses,
                    removeAction: { store.send(.removeExpense($0)) }
                )
            }
        }
        .navigationTitle("iExpense")
        .toolbar{
            Button {
                store.send(.openAddExpenseSheet)
            } label: {
                Image(systemName: "plus")
            }
        }
        .onAppear { store.send(.viewAppeared) }
        .sheet(isPresented: Binding(
                get: { store.showingAddExpense },
                set: { _ in store.send(.closeAddExpenseSheet) })
        ) {
            AddExpense { store.send(.addExpense($0)) }
        }
    }
    
    //MARK: - init(_:)
    public init(
        store: StoreOf<ExpensesDomain> = ExpensesDomain.liveStore
    ) {
        self._store = StateObject(wrappedValue: store)
    }
    
}

#Preview {
    NavigationStack {
        iExpenseView(store: ExpensesDomain.previewStore)
    }
}
