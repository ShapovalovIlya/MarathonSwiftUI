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
            VStack(alignment: .leading, spacing: 0) {
                Text("When do you want to wake up?")
                    .font(.headline)
                DatePicker(
                    "Please enter a time",
                    selection: Binding(
                        get: { store.wakeUp },
                        set: { store.send(.setWakeUpDate($0)) }),
                    in: Date.now...,
                    displayedComponents: .hourAndMinute
                )
                .labelsHidden()
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Desired amount to sleep")
                    .font(.headline)
                Stepper(
                    "\(store.sleepAmount.formatted()) hours",
                    value: Binding(
                        get: { store.sleepAmount },
                        set: { store.send(.setSleepAmount($0)) }),
                    in: 4...12,
                    step: 0.25
                )
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Daily coffee intake")
                    .font(.headline)
                Stepper(
                    store.coffeeCupsTitle,
                    value: Binding(
                        get: { store.coffeeAmount },
                        set: { store.send(.setCoffeeAmount($0)) }),
                    in: 0...20
                )
            }
        }
        .navigationTitle("Better rest")
        .toolbar {
            Button("Calculate", action: { store.send(.calculateButtonTap) })
        }
        .alert(
            store.alertTitle,
            isPresented: Binding(
                get: { store.isAlertShown },
                set: { _ in store.send(.dismissAlert) })
        ) {
            Button("Ok", role: .cancel, action: {})
        } message: {
            Text(store.alertMessage)
        }
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
        NavigationStack {
            BetterRestView(store: BetterRestDomain.previewStoreAlertState)
        }
        .previewDisplayName("alert state")
    }
}
