//
//  OrderDomain.swift
//
//
//  Created by Илья Шаповалов on 20.08.2023.
//

import Foundation
import SwiftUDF
import SwiftFP
import Combine
import OSLog

public struct OrderDomain: ReducerDomain {
    public typealias State = Order
    
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: Self.self)
    )
    
    //MARK: - State
    public struct Order: Codable {
        public var type: CupcakeType
        public var quantity: Int
        public var specialRequestEnabled: Bool
        public var extraFrosting: Bool
        public var addSprinkles: Bool
        
        public init(
            type: CupcakeType = .vanilla,
            quantity: Int = 3,
            specialRequestEnabled: Bool = false,
            extraFrosting: Bool = false,
            addSprinkles: Bool = false
        ) {
            self.type = type
            self.quantity = quantity
            self.specialRequestEnabled = specialRequestEnabled
            self.extraFrosting = extraFrosting
            self.addSprinkles = addSprinkles
        }
    }
    
    //MARK: - Action
    public enum Action: Equatable {
        case setCupcakeType(State.CupcakeType)
    }
    
    //MARK: - Dependencies
    
    //MARK: - init(_:)
    public init() {}
    
    //MARK: - Reducer
    public func reduce(_ state: inout State, action: Action) -> AnyPublisher<Action, Never> {
        switch action {
        case let .setCupcakeType(type):
            state.type = type
        }
        
        return empty()
    }
    
    
}

//MARK: - Store
public extension OrderDomain {
    static let previewStore = Store(
        state: Self.State(),
        reducer: Self()
    )
    
    static let liveStore = Store(
        state: Self.State(),
        reducer: Self()
    )
}

//MARK: - Cupcake type
public extension OrderDomain.Order {
    enum CupcakeType: String, Codable, CaseIterable {
        case vanilla
        case strawberry
        case chocolate
        case rainbow
    }
}
