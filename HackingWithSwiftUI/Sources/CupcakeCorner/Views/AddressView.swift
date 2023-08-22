//
//  AddressView.swift
//  
//
//  Created by Илья Шаповалов on 22.08.2023.
//

import SwiftUI
import SwiftUDF

struct AddressView: View {
    @StateObject private var store: StoreOf<AddressDomain>
    private let order: OrderDomain.Order
    
    var body: some View {
        Form {
            Section {
                TextField(
                    "Name",
                    text: bindName()
                )
                TextField(
                    "Street Address",
                    text: bindAddress()
                )
                TextField(
                    "City",
                    text: bindCity()
                )
                TextField(
                    "Zip",
                    text: bindZip()
                )
            }
            Section {
                NavigationLink("Check out") {
                    CheckoutView()
                }
            }
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    init(
        store: StoreOf<AddressDomain> = AddressDomain.previewStore,
        order: OrderDomain.Order
    ) {
        self._store = StateObject(wrappedValue: store)
        self.order = order
    }
}

private extension AddressView {
    func bindName() -> Binding<String> {
        Binding(
            get: { store.name },
            set: { store.send(.setName($0)) }
        )
    }
    
    func bindAddress() -> Binding<String> {
        Binding(
            get: { store.streetAddress },
            set: { store.send(.setStreetAddress($0)) }
        )
    }
    
    func bindCity() -> Binding<String> {
        Binding(
            get: { store.city },
            set: { store.send(.setCity($0)) }
        )
    }
    
    func bindZip() -> Binding<String> {
        Binding(
            get: { store.zip },
            set: { store.send(.setZip($0)) }
        )
    }
}

#Preview {
    AddressView(order: .init())
}
