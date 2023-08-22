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
    private let deliveryButtonTap: (OrderDomain.Order) -> Void
    
    public var body: some View {
        Form {
            Section {
                Picker(
                    "Select your cake",
                    selection: bindCakeType(),
                    content: cakeTypes
                )
                
                Stepper(
                    "Number of cakes \(store.quantity)",
                    value: bindQuantity(),
                    in: 3...20
                )
            }
            
            Section {
                Toggle(
                    "Any special requests?",
                    isOn: bindSpecialRequest()
                )
                
                if store.specialRequestEnabled {
                    Toggle(
                        "Add extra frosting",
                        isOn: bindExtraFrosting()
                    )
                    Toggle(
                        "Add extra sprinkles",
                        isOn: bindExtraSprinkles()
                    )
                }
            }
            
            Section {
                Button("Delivery details") {
                    deliveryButtonTap(store.state)
                }
            }
            
        }
    }
    
    //MARK: - init(_:)
    public init(
        order: OrderDomain.Order,
        deliveryButtonTap: @escaping (OrderDomain.Order) -> Void
    ) {
        let store = Store(state: order, reducer: OrderDomain())
        self._store = StateObject(wrappedValue: store)
        self.deliveryButtonTap = deliveryButtonTap
    }
    
}

//MARK: - Private methods
private extension OrderView {
    func bindExtraSprinkles() -> Binding<Bool> {
        Binding(
            get: { store.addSprinkles },
            set: { store.send(.toggleAddSprinkles($0)) }
        )
    }
    
    func bindExtraFrosting() -> Binding<Bool> {
        Binding(
            get: { store.extraFrosting },
            set: { store.send(.toggleExtraFrosting($0)) }
        )
    }
    
    func bindSpecialRequest()  -> Binding<Bool> {
        Binding(
            get: { store.specialRequestEnabled },
            set: { store.send(.toggleSpecialRequest($0)) }
        )
    }
    
    func bindQuantity() -> Binding<Int> {
        Binding(
            get: { store.quantity },
            set: { store.send(.setQuantity($0)) }
        )
    }
    
    func bindCakeType() -> Binding<OrderDomain.Order.CupcakeType> {
        Binding(
            get: { store.type },
            set: { store.send(.setCupcakeType($0)) }
        )
    }
    
    func cakeTypes() -> some View {
        ForEach(OrderDomain.Order.CupcakeType.allCases, id: \.self) { cake in
            Text(cake.rawValue)
        }
    }
}

#Preview {
    OrderView(order: .init(), deliveryButtonTap: { _ in })
}
