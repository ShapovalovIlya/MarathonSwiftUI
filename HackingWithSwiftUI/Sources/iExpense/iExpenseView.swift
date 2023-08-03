//
//  iExpenseView.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 03.08.2023.
//

import SwiftUI
import SwiftUDF
import Shared

public struct iExpenseView: View {
    @StateObject var store: StoreOf<ExpensesDomain>
    
    //MARK: - body
    public var body: some View {
        List {
            ForEach(store.expenses) { expense in
                ExpenseRow(expense: expense)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            store.send(.removeExpense(expense))
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        
                    }
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
        .sheet(
            isPresented: Binding(
                get: { store.showingAddExpense },
                set: { _ in store.send(.closeAddExpenseSheet) })
        ) {
           AddExpense(store: store)
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
