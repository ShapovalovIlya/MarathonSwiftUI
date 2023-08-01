//
//  GameDomain.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 01.08.2023.
//

import Foundation
import Combine
import SwiftUDF

public struct GameDomain: ReducerDomain {
    //MARK: - State
    public struct State {
        
        public init() {}
    }
    
    //MARK: - Action
    public enum Action: Equatable {
        
    }
    
    //MARK: - init(_:)
    public init() {}
    
    //MARK: - Reducer
    public func reduce(_ state: inout State, action: Action) -> AnyPublisher<Action, Never> {
        
        return Empty().eraseToAnyPublisher()
    }
    
    //MARK: - Preview store
    static let previewStore = Store(
        state: Self.State(),
        reducer: Self()
    )
}
