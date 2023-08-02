//
//  RootDomain.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 01.08.2023.
//

import Foundation
import Combine
import SwiftUDF
import AppDependencies

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
    
    private let compileMessage: (Int, Int) -> String
    
    //MARK: - init(_:)
    public init(compileMessage: @escaping (Int, Int) -> String = MessageGenerator.compileMessage) {
        self.compileMessage = compileMessage
    }
    
    //MARK: - Reducer
    public func reduce(_ state: inout State, action: Action) -> AnyPublisher<Action, Never> {
        switch action {
        case let .commitSettings(settings):
            let gameState = GameDomain.State(
                lhs: settings.tableDifficult,
                maxQuestions: settings.totalQuestions)
            state = .game(gameState)
            
        case let .commitGameResult(result):
            let score = Score(
                score: result.score,
                questionsCount: result.maxQuestions,
                message: compileMessage(result.score, result.maxQuestions)
            )
            state = .score(score)
        }
        
        return Empty().eraseToAnyPublisher()
    }
    
    //MARK: - Preview store
    public static let previewStore = Store(
        state: Self.State(),
        reducer: Self()
    )
}
