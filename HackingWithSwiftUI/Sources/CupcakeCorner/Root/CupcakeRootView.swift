//
//  RootView.swift
//  
//
//  Created by Илья Шаповалов on 22.08.2023.
//

import SwiftUI
import SwiftUDF

public struct CupcakeRootView: View {
    @StateObject private var store: StoreOf<RootDomain>
    
    private let transition: AnyTransition = .slide
    
    //MARK: - Body
    public var body: some View {
        VStack {
            Group {
                switch store.userScenario {
                case .order:
                    OrderView(
                        order: store.order,
                        deliveryButtonTap: { store.send(.deliveryButtonTap($0)) }
                    )
                    .transition(transition)
                    
                case .address:
                    AddressView(
                        address: store.address,
                        checkoutButtonTap: { store.send(.checkoutButtonTap($0)) }
                    )
                    .transition(transition)
                    
                case .checkout:
                    CheckoutView(
                        cost: store.order.cost,
                        placeOrderButtonTap: { store.send(.placeOrderButtonTap) }
                    )
                    .transition(transition)
                }
            }
            .animation(.easeInOut, value: store.userScenario)
        }
        .navigationTitle(store.userScenario.navigationTitle)
        .navigationBarBackButtonHidden(store.userScenario != .order)
        .navigationBarTitleDisplayMode(setNavTitleMode())
        .toolbar {
            if store.userScenario != .order {
                BackButton {
                    store.send(.backButtonTap)
                }
            }
        }
        .alert(
            "Thank you!",
            isPresented: bindConfirmation()
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(store.alertMessage)
        }

    }
    
    //MARK: - init(_:)
    public init(store: StoreOf<RootDomain> = RootDomain.liveStore) {
        self._store = StateObject(wrappedValue: store)
    }
    
    //MARK: - Private methods
    private func setNavTitleMode() -> NavigationBarItem.TitleDisplayMode {
        switch store.userScenario {
        case .order: return .large
        case .address: return .inline
        case .checkout: return .inline
        }
    }
    
    private func bindConfirmation() -> Binding<Bool> {
        Binding(
            get: { store.showAlert },
            set: { _ in store.send(.dismissAlert) }
        )
    }
}

//MARK: - Preview
#Preview("Initial") {
    CupcakeRootView(store: RootDomain.previewStore)
}

#Preview("Alert") {
    CupcakeRootView(store: RootDomain.previewAlertStore)
}
