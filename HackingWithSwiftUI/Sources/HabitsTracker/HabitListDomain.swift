//
//  HabitListDomain.swift
//  
//
//  Created by Илья Шаповалов on 18.08.2023.
//

import Foundation
import SwiftUDF
import Combine
import AppDependencies
import OSLog

public struct HabitListDomain: ReducerDomain {
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: Self.self)
    )
    
    //MARK: - State
    public struct State {
        
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
    
    //MARK: - Preview store
    static let previewStore = Store(
        state: Self.State(),
        reducer: Self()
    )
    
    //MARK: - Live store
    public static let liveStore = Store(
        state: Self.State(),
        reducer: Self()
    )
}
