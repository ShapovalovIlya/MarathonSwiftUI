//
//  UnitConversionsDomain.swift
//  
//
//  Created by User on 18.07.2023.
//

import Foundation
import SwiftUDF
import Combine

public struct UnitConversionsDomain: ReducerDomain {
    //MARK: - State
    public struct State {
        public var type: UnitTypes
        
        public init() {
            self.type = .temperature
        }
    }
    
    //MARK: - Action
    public enum Action {
        case setUnitType(UnitTypes)
    }
    
    //MARK: - init(_:)
    public init() {}
    
    //MARK: - Reducer
    public func reduce(_ state: inout State, action: Action) -> AnyPublisher<Action, Never> {
        switch action {
        case let .setUnitType(unitType):
            state.type = unitType

        }
        return Empty().eraseToAnyPublisher()
    }
    
    public static let previewStore = Store(
        state: Self.State(),
        reducer: Self())
}

private extension UnitConversionsDomain {
    
}
