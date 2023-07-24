//
//  BetterRestView.swift
//  
//
//  Created by Илья Шаповалов on 23.07.2023.
//

import SwiftUI
import SwiftUDF

public struct BetterRestView: View {
    @ObservedObject private var store: StoreOf<BetterRestDomain>
    
    public var body: some View {
        Form {
            Section {
                Text(store.alertMessage)
            } header: {
                Text(store.alertTitle)
            }
            Section {
                DatePicker(
                    "Please enter a time",
                    selection: Binding(
                        get: { store.wakeUp },
                        set: { store.send(.setWakeUpDate($0)) }),
                    in: Date.now...,
                    displayedComponents: .hourAndMinute
                )
                .labelsHidden()
            } header: {
                Text("When do you want to wake up?")
            }
            Section {
                Stepper(
                    "\(store.sleepAmount.formatted()) hours",
                    value: Binding(
                        get: { store.sleepAmount },
                        set: { store.send(.setSleepAmount($0)) }),
                    in: 4...12,
                    step: 0.25
                )
            } header: {
                Text("Desired amount to sleep")
            }
            Section {
                Picker(
                    store.coffeeCupsTitle,
                    selection: Binding(
                        get: { store.coffeeAmount },
                        set: { store.send(.setCoffeeAmount($0)) })
                ) {
                    ForEach(Range<Int>(0...20)) { amount in
                        Text(amount.description)
                            .tag(amount)
                    }
                }
            } header: {
                Text("Daily coffee intake")
            }
        }
        .navigationTitle("Better rest")
        .onAppear { store.send(.calculateSleep) }
    }
    
    public init(store: StoreOf<BetterRestDomain>) {
        self.store = store
    }
}

struct BetterRestView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            BetterRestView(store: BetterRestDomain.previewStore)
        }
        .previewDisplayName("initial state")
    }
}
