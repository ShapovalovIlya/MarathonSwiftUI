//
//  OrderView.swift
//  
//
//  Created by Илья Шаповалов on 21.08.2023.
//

import SwiftUI
import SwiftUDF

public struct OrderView: View {
    @StateObject private var store: StoreOf<OrderDomain>
    
    public var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker(
                        "Select your cake",
                        selection: bindCakeType(),
                        content: cakeTypes
                    )
                    
                    
                }
            }
            .navigationTitle("Cupcake order")
        }
    }
    
    //MARK: - init(_:)
    public init(store: StoreOf<OrderDomain> = OrderDomain.liveStore) {
        self._store = StateObject(wrappedValue: store)
    }
    
}

//MARK: - Private methods
private extension OrderView {
    func bindCakeType() -> Binding<OrderDomain.Order.CupcakeType> {
        Binding(
            get: { store.type },
            set: { _ in }
        )
    }
    
    func cakeTypes() -> some View {
        ForEach(OrderDomain.Order.CupcakeType.allCases, id: \.self) { cake in
            Text(cake.rawValue.uppercased())
        }
    }
}

#Preview {
    OrderView(store: OrderDomain.previewStore)
}
