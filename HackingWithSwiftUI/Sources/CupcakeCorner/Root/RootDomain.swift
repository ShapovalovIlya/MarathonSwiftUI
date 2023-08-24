//
//  File.swift
//  
//
//  Created by Илья Шаповалов on 22.08.2023.
//

import Foundation
import SwiftUDF
import Combine
import AppDependencies

public struct RootDomain: ReducerDomain {
    public typealias SendOrderPublisher = (OrderDomain.Order) -> AnyPublisher<OrderDomain.Order, Error>
    
    //MARK: - State
    public struct State {
        public var order: OrderDomain.Order
        public var address: AddressDomain.State
        public var alertMessage: String
        public var showAlert: Bool
        public var userScenario: Scenario
        
        public init(
            order: OrderDomain.Order = .init(),
            address: AddressDomain.State = .init(),
            alertMessage: String = .init(),
            showAlert: Bool = false,
            userScenario: Scenario = .init()
        ) {
            self.order = order
            self.address = address
            self.alertMessage = alertMessage
            self.showAlert = showAlert
            self.userScenario = userScenario
        }
    }
    
    //MARK: - Action
    public enum Action: Equatable {
        case viewAppeared
        case deliveryButtonTap(OrderDomain.Order)
        case checkoutButtonTap(AddressDomain.State)
        case placeOrderButtonTap
        case backButtonTap
        case sendOrderRequest
        case sendOrderResponse(Result<OrderDomain.Order, Error>)
        case dismissAlert
        
        public static func == (lhs: RootDomain.Action, rhs: RootDomain.Action) -> Bool {
            String(describing: lhs) == String(describing: rhs)
        }
    }
    
    //MARK: - Dependencies
    private let sendOrder: SendOrderPublisher
    
    //MARK: - init(_:)
    public init(
        sendOrder: @escaping SendOrderPublisher = ApiClient.shared.send(order:)
    ) {
        self.sendOrder = sendOrder
    }
    
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
            
        case .placeOrderButtonTap:
            return run(.sendOrderRequest)
            
        case .sendOrderRequest:
            return sendOrder(state.order)
                .map(transformToSuccessAction)
                .catch(catchToFailAction)
                .eraseToAnyPublisher()
            
        case let .sendOrderResponse(.success(order)):
            state.alertMessage = "Your order for \(order.quantity)x \(order.type.rawValue) cupcakes is on its way!"
            state.showAlert = true
            
        case let .sendOrderResponse(.failure(error)):
            print(error.localizedDescription)
            state.alertMessage = "Unable to send order. Try again later."
            state.showAlert = true
            
        case .backButtonTap:
            switch state.userScenario {
            case .order:
                break
            case .address:
                state.userScenario = .order
            case .checkout:
                state.userScenario = .address
            }
            
        case .dismissAlert:
            state.showAlert = false
            
        }
        return empty()
    }
    
    //MARK: - previewStore
    static let previewStore = Store(
        state: Self.State(),
        reducer: Self(sendOrder: { order in
            Just(order)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        })
    )
    
    static let previewAlertStore = Store(
        state: Self.State(alertMessage: "Some alert message!", showAlert: true),
        reducer: Self()
    )
    
    public static let liveStore = Store(
        state: Self.State(),
        reducer: Self()
    )
}

//MARK: - Private methods
private extension RootDomain {
    func transformToSuccessAction(_ order: OrderDomain.Order) -> Action {
        .sendOrderResponse(.success(order))
    }
    
    func catchToFailAction(_ error: Error) -> Just<Action> {
        .init(.sendOrderResponse(.failure(error)))
    }
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
