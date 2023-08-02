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
    public struct State: Equatable {
        public var lhs: Int
        public var rhs: Int
        public var currentQuestion: Int
        public var maxQuestions: Int
        public var guess: Int
        public var score: Int
        public var alertTitle: String
        public var isAlertShown: Bool
        public var isGameOver: Bool
        
        public init(
            lhs: Int,
            rhs: Int = .init(),
            currentQuestion: Int = .init(),
            maxQuestions: Int,
            guess: Int = .init(),
            score: Int = .init(),
            alertTitle: String = .init(),
            isAlertShown: Bool = false,
            isGameOver: Bool = false
        ) {
            self.lhs = lhs
            self.rhs = rhs
            self.currentQuestion = currentQuestion
            self.maxQuestions = maxQuestions
            self.guess = guess
            self.score = score
            self.alertTitle = alertTitle
            self.isAlertShown = isAlertShown
            self.isGameOver = isGameOver
        }
    }
    
    //MARK: - Action
    public enum Action: Equatable {
        case askQuestion
        case setGuess(Int)
        case resolveButtonTap
        case guessIsCorrect(Bool)
        case continueButtonTap
        case gameOver
        case dismissAlert
    }
    
    //MARK: - Dependencies
    private let randomInt: () -> Int
    
    //MARK: - init(_:)
    public init(
        randomInt: @escaping () -> Int = { .random(in: 2...10) }
    ) {
        self.randomInt = randomInt
    }
    
    //MARK: - Reducer
    public func reduce(_ state: inout State, action: Action) -> AnyPublisher<Action, Never> {
        switch action {
        case .askQuestion:
            state.rhs = randomInt()
            state.currentQuestion += 1
            
        case let .setGuess(guess):
            state.guess = guess
            
        case .resolveButtonTap:
            let correctAnswer = state.lhs * state.rhs
            
            return Publishers.Zip(
                Just(state.guess),
                Just(correctAnswer)
            )
            .map(==)
            .map(Action.guessIsCorrect)
            .eraseToAnyPublisher()
            
        case let .guessIsCorrect(isCorrect):
            setup(&state, withAnswerResult: isCorrect)
            
        case .continueButtonTap:
            return Just(state)
                .map(reduceGameFlow(_:))
                .eraseToAnyPublisher()
            
        case .gameOver:
            state.isGameOver = true
            state.alertTitle = "Game over!"
            
        case .dismissAlert:
            state.isAlertShown = false
            
        }
        return Empty().eraseToAnyPublisher()
    }
    
    //MARK: - Preview store
    static let previewStore = Store(
        state: Self.State(lhs: 2, maxQuestions: 5),
        reducer: Self()
    )
    
    static let previewStoreAlertState = Store(
        state: Self.State(
            lhs: 2,
            maxQuestions: 5,
            alertTitle: "You right!",
            isAlertShown: true
        ),
        reducer: Self()
    )
    
    static let previewStoreGameOverState = Store(
        state: Self.State(
            lhs: 2,
            maxQuestions: 5,
            alertTitle: "You right!",
            isGameOver: true
        ),
        reducer: Self()
    )
}

private extension GameDomain {
    func setup(_ state: inout State, withAnswerResult isCorrect: Bool) {
        switch isCorrect {
        case true:
            state.alertTitle = "You right!"
            state.score += 1
            
        case false:
            state.alertTitle = "Wrong answer"
        }
        state.isAlertShown = true
    }
    
    func reduceGameFlow(_ state: State) -> Action {
        guard state.currentQuestion < state.maxQuestions else {
            return .gameOver
        }
        return .askQuestion
    }
}
