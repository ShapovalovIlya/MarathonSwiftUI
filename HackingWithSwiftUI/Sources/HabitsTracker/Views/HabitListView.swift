//
//  HabitListView.swift
//  
//
//  Created by Илья Шаповалов on 19.08.2023.
//

import SwiftUI
import SwiftUDF

public struct HabitListView: View {
    @StateObject private var store: StoreOf<HabitListDomain>
    
    public var body: some View {
        NavigationStack {
            List {
                if store.habits.isEmpty {
                    Button("Add habit") {
                        store.send(.addHabitButtonTap)
                    }
                } else {
                    ForEach(store.habits) { habit in
                        NavigationLink(habit.title) {
                            EmptyView()
                        }
                    }
                    .onDelete(perform: removeHabitAction)
                    .onMove(perform: moveHabitAction)
                }
            }
            .navigationTitle("My habits")
            .onAppear { store.send(.viewAppeared) }
            .toolbar {
                TrailingContent {
                    store.send(.addHabitButtonTap)
                }
            }
            .sheet(
                isPresented: bindSheet(),
                content: addHabitSheet)
            .alert(
                "Unable to save habits.",
                isPresented: bindAlert(),
                actions: { Button("OK", role: .cancel, action: {}) }
            )
        }
    }
    
    //MARK: - init(_:)
    public init(store: StoreOf<HabitListDomain> = HabitListDomain.liveStore) {
        self._store = StateObject(wrappedValue: store)
    }
    
    //MARK: - Private methods
    private func removeHabitAction(_ indexSet: IndexSet) {
        store.send(.removeHabitAtOffset(indexSet))
    }
    
    private func moveHabitAction(_ indexSet: IndexSet, _ index: Int) {
        store.send(.moveHabit(from: indexSet, to: index))
    }
    
    private func bindSheet() -> Binding<Bool> {
        Binding(
            get: { store.isShowSheet },
            set: { _ in store.send(.dismissSheet) }
        )
    }
    
    private func bindAlert() -> Binding<Bool> {
        Binding(
            get: { store.isAlert },
            set: { _ in store.send(.dismissAlert) }
        )
    }
    
    private func addHabitSheet() -> some View {
        EmptyView()
    }
}

//#Preview {
//    HabitListView(store: HabitListDomain.previewStore)
//}
