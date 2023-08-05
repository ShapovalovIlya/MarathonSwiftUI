//
//  ContentView.swift
//  WeSplitView
//
//  Created by User on 16.07.2023.
//

import SwiftUI
import SwiftUDF

public struct WeSplitView: View {
    @StateObject var store: StoreOf<WeSplitDomain>
    @FocusState private var amountIsFocused: Bool
    private let format: FloatingPointFormatStyle<Double>.Currency = .currency(code: Locale.current.currency?.identifier ?? "USD")
    
    public var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(
                        "Amount",
                        value: Binding(
                            get: { store.checkAmount },
                            set: { store.send(.setCheckAmount($0)) }),
                        format: format
                    )
                    .keyboardType(.decimalPad)
                    .focused($amountIsFocused)
                    
                    Picker(
                        "Number of people",
                        selection: Binding(
                            get: { store.numberOfPeople },
                            set: { store.send(.setNumberOfPeople($0)) })
                    ) {
                        ForEach(2..<100) { index in
                            Text("\(index) people")
                        }
                    }
                } header: {
                    Text("Total bill.")
                }
                
                Section {
                    Picker(
                        "Tip percentage",
                        selection: Binding(
                            get: { store.tip },
                            set: { store.send(.setTip($0)) })
                    ) {
                        ForEach(TipPercent.allCases, id: \.self) { tip in
                            Text(tip.rawValue, format: .percent)
                        }
                    }
                    .pickerStyle(.segmented)
                    Text(store.billWithTips, format: format)
                } header: {
                    Text("How much tip do you want to leave?")
                }
                
                Section {
                    Text(
                        store.totalPerPerson,
                        format: format
                    )
                    .foregroundColor(
                        store.tip == .zero
                        ? .red
                        : .black)
                } header: {
                    Text("Total per person.")
                }

            }
            .navigationTitle("We split.")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
    
    public init(store: StoreOf<WeSplitDomain> = WeSplitDomain.previewStore) {
        self._store = StateObject(wrappedValue: store)
    }
    
}

struct WeSplit_Previews: PreviewProvider {
    static var previews: some View {
        WeSplitView(store: WeSplitDomain.previewStore)
    }
}
