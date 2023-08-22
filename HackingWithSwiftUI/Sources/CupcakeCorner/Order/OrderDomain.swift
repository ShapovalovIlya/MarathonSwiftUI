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
    public struct Order: Codable, Equatable {
        public var type: CupcakeType
        public var quantity: Int
        public var specialRequestEnabled: Bool
        public var extraFrosting: Bool
        public var addSprinkles: Bool
        
        public var cost: Double {
            var cost = Double(quantity) * 2
            cost += type.cost
            if extraFrosting {
                cost += Double(quantity)
            }
            if addSprinkles {
                cost += Double(quantity) / 2
            }
            
            return cost
        }
        
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
        case setQuantity(Int)
        case toggleSpecialRequest(Bool)
        case toggleExtraFrosting(Bool)
        case toggleAddSprinkles(Bool)
    }
    
    //MARK: - Dependencies
    
    //MARK: - init(_:)
    public init() {}
    
    //MARK: - Reducer
    public func reduce(_ state: inout State, action: Action) -> AnyPublisher<Action, Never> {
        switch action {
        case let .setCupcakeType(type):
            state.type = type
            
        case let .setQuantity(quantity):
            state.quantity = quantity
            
        case let .toggleSpecialRequest(enabled):
            state.specialRequestEnabled = enabled
            if !state.specialRequestEnabled {
                state.extraFrosting = false
                state.addSprinkles = false
            }
            
        case let .toggleExtraFrosting(enabled):
            state.extraFrosting = enabled
            
        case let .toggleAddSprinkles(enabled):
            state.addSprinkles = enabled
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
        
        var cost: Double {
            switch self {
            case .vanilla: return 0.5
            case .strawberry: return 0.75
            case .chocolate: return 1.0
            case .rainbow: return 1.25
            }
        }
    }
}
