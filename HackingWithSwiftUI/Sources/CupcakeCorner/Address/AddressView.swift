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
    private let checkoutButtonTap: (AddressDomain.State) -> Void
    
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
                Button("Check out") {
                    checkoutButtonTap(store.state)
                }
                .disabled(!store.hasValidAddress)
            }
        }
    }
    
    init(
        address: AddressDomain.State,
        checkoutButtonTap: @escaping (AddressDomain.State) -> Void
    ) {
        let store = Store(state: address, reducer: AddressDomain())
        self._store = StateObject(wrappedValue: store)
        self.checkoutButtonTap = checkoutButtonTap
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
    AddressView(address: .init(), checkoutButtonTap: { _ in })
}
