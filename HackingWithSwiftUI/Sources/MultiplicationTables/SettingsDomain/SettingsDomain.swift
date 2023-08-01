//
//  SettingsDomain.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 01.08.2023.
//

import Foundation
import SwiftUDF
import Combine

public struct SettingsDomain: ReducerDomain {
    //MARK: - State
    public struct State {
        public var tableDifficult: Int
        public var totalQuestions: Int
        
        public init(
            tableDifficult: Int = 2,
            totalQuestions: Int = 5
        ) {
            self.tableDifficult = tableDifficult
            self.totalQuestions = totalQuestions
        }
    }
    
    //MARK: - Action
    public enum Action: Equatable {
        case setDifficult(Int)
        case setTotalQuestions(Int)
    }
    
    //MARK: - init(_:)
    public init() {}
    
    //MARK: - Reducer
    public func reduce(_ state: inout State, action: Action) -> AnyPublisher<Action, Never> {
        switch action {
        case let .setDifficult(table):
            state.tableDifficult = table
            
        case let .setTotalQuestions(totalQuestions):
            state.totalQuestions = totalQuestions
        }
        
        return Empty().eraseToAnyPublisher()
    }
    
    //MARK: - Preview store
    static let previewStore = Store(
        state: Self.State(),
        reducer: Self()
    )
}
