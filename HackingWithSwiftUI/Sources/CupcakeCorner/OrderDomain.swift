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
        var type: Int
        var quantity: Int
        var specialRequestEnabled: Bool
        var extraFrosting: Bool
        var addSprinkles: Bool
        
        public init(
        type: Int = 0,
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
        
    }
    
    //MARK: - Dependencies
    
    //MARK: - init(_:)
    public init() {}
    
    //MARK: - Reducer
    public func reduce(_ state: inout State, action: Action) -> AnyPublisher<Action, Never> {
        
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
