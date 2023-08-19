//
//  HabitDetailView.swift
//
//
//  Created by Илья Шаповалов on 19.08.2023.
//

import SwiftUI
import SwiftUDF

struct HabitDetailView: View {
    @StateObject private var store: StoreOf<HabitDomain>
    @Environment(\.dismiss) private var dismiss
    let onCommit: (Habit) -> Void
    
    var body: some View {
        NavigationStack {
            List {
                Section("Habit") {
                    TextField(
                        "Type title for your habit",
                        text: bindTitle()
                    )
                    TextField(
                        "Here you cat type short description...",
                        text: bindDescription()
                    )
                    Text("Count of times: \(store.count)")
                }
                Section {
                    Button("Increment habit count") {
                        store.send(.incrementButtonTap)
                    }
                }
                Section {
                    Button("Submit") {
                        onCommit(store.state)
                        dismiss()
                    }
                }
            }
            .navigationTitle(store.title)
            .toolbar(content: CancelButton.init)
        }
    }
    
    //MARK: - init(_:)
    init(
        habit: Habit = .init(),
        onCommit: @escaping (Habit) -> Void
    ) {
        let store = Store(state: habit, reducer: HabitDomain())
        self._store = StateObject(wrappedValue: store)
        self.onCommit = onCommit
    }
    
    //MARK: - Private methods
    private func bindTitle() -> Binding<String> {
        Binding(
            get: { store.title },
            set: { store.send(.setTitle($0)) }
        )
    }
    
    private func bindDescription() -> Binding<String> {
        Binding(
            get: { store.description },
            set: { store.send(.setDescription($0)) }
        )
    }
}

#Preview("Empty") {
    HabitDetailView(onCommit: { _ in })
}

#Preview("Refactor") {
    HabitDetailView(habit: .sample[0], onCommit: { _ in })
}
