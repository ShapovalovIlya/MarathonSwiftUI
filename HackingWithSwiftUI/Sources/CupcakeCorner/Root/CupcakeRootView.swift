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
                    CheckoutView()
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
    }
    
    public init(store: StoreOf<RootDomain> = RootDomain.liveStore) {
        self._store = StateObject(wrappedValue: store)
    }
    
    private func setNavTitleMode() -> NavigationBarItem.TitleDisplayMode {
        switch store.userScenario {
        case .order: return .large
        case .address: return .inline
        case .checkout: return .large
        }
    }
}

#Preview {
    CupcakeRootView(store: RootDomain.previewStore)
}
