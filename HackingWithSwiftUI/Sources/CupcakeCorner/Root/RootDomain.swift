//
//  File.swift
//  
//
//  Created by Илья Шаповалов on 22.08.2023.
//

import Foundation
import SwiftUDF
import Combine

public struct RootDomain: ReducerDomain {
    //MARK: - State
    public struct State {
        public var order: OrderDomain.Order
        public var address: AddressDomain.State
        public var userScenario: Scenario
        
        public init(
            order: OrderDomain.Order = .init(),
            address: AddressDomain.State = .init(),
            userScenario: Scenario = .init()
        ) {
            self.order = order
            self.address = address
            self.userScenario = userScenario
        }
    }
    
    //MARK: - Action
    public enum Action: Equatable {
        case viewAppeared
        case deliveryButtonTap(OrderDomain.Order)
        case checkoutButtonTap(AddressDomain.State)
        case backButtonTap
    }
    
    //MARK: - Dependencies
    
    //MARK: - init(_:)
    public init() {}
    
    //MARK: - Reducer
    public func reduce(_ state: inout State, action: Action) -> AnyPublisher<Action, Never> {
        switch action {
        case .viewAppeared:
            state.userScenario = .order
            
        case let .deliveryButtonTap(order):
            state.order = order
            state.userScenario = .address
            
        case let .checkoutButtonTap(address):
            state.address = address
            state.userScenario = .checkout
            
        case .backButtonTap:
            switch state.userScenario {
            case .order:
                break
            case .address:
                state.userScenario = .order
            case .checkout:
                state.userScenario = .address
            }
            
        }
        return empty()
    }
    
    //MARK: - previewStore
    static let previewStore = Store(
        state: Self.State(),
        reducer: Self()
    )
    
    public static let liveStore = Store(
        state: Self.State(),
        reducer: Self()
    )
}

//MARK: - Scenario
public extension RootDomain.State {
    enum Scenario: Equatable {
        case order
        case address
        case checkout
        
        public init() {
            self = .order
        }
        
        var navigationTitle: String {
            switch self {
            case .order: return "Cupcake order"
            case .address: return "Delivery details"
            case .checkout: return "Checkout"
            }
        }
    }
}
