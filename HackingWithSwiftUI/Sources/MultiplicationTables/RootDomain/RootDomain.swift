//
//  RootDomain.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 01.08.2023.
//

import Foundation
import Combine
import SwiftUDF

public struct Score: Equatable {
    let score: Int
    let questionsCount: Int
    let message: String
}

public struct RootDomain: ReducerDomain {
    //MARK: - State
    public enum State: Equatable {
        case settings
        case game(GameDomain.State)
        case score(Score)
        
        public init() {
            self = .settings
        }
    }
    
    //MARK: - Action
    public enum Action: Equatable {
        case commitSettings(SettingsDomain.State)
        case commitGameResult(GameDomain.State)
    }
    
    //MARK: - init(_:)
    public init() {}
    
    //MARK: - Reducer
    public func reduce(_ state: inout State, action: Action) -> AnyPublisher<Action, Never> {
        switch action {
        case let .commitSettings(settings):
            state = .game(.init(
                    lhs: settings.tableDifficult,
                    maxQuestions: settings.totalQuestions)
            )
            
        case let .commitGameResult(result):
            break
            
        }
        
        return Empty().eraseToAnyPublisher()
    }
    
    //MARK: - Preview store
    public static let previewStore = Store(
        state: Self.State(),
        reducer: Self()
    )
}
