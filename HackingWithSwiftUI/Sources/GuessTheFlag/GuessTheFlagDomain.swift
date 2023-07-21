//
//  GuessTheFlagDomain.swift
//  GuesTheFlag
//
//  Created by User on 17.07.2023.
//

import Foundation
import Combine
import SwiftUDF

public struct GuessTheFlagDomain: ReducerDomain {
    //MARK: - State
    public struct State: Equatable {
        var score: Int
        var countries: [String]
        var showScore: Bool
        var showFinalScore: Bool
        var scoreTitle: String
        var currentNumberOfQuestions: Int
        var totalQuestions: Int
        var correctAnswer: Int
        var currentFlag: String {
            countries[correctAnswer]
        }
        
        //MARK: - init(_:)
        public init() {
            score = 0
            countries = [
                "Estonia",
                "France",
                "Germany",
                "Ireland",
                "Italy",
                "Nigeria",
                "Poland",
                "Russia",
                "Spain",
                "UK",
                "US"
            ]
            showScore = false
            showFinalScore = false
            scoreTitle = .init()
            currentNumberOfQuestions = .init()
            totalQuestions = 8
            correctAnswer = .random(in: 0...2)
        }
    }
    
    //MARK: - Action
    public enum Action: Equatable {
        case askQuestion
        case tapOnFlag(String)
        case rightAnswer
        case wrongAnswer(String)
        case closeAlert
        case showFinalScore
        case restartGame
    }
    
    //MARK: - init(_:)
    public init() {}
    
    //MARK: - Reducer
    public func reduce(_ state: inout State, action: Action) -> AnyPublisher<Action, Never> {
        switch action {
        case .askQuestion:
            guard state.currentNumberOfQuestions != 8 else {
                return Just(.showFinalScore).eraseToAnyPublisher()
            }
            state.countries.shuffle()
            state.correctAnswer = .random(in: 0..<2)
            state.currentNumberOfQuestions += 1
            
        case let .tapOnFlag(country):
            if country == state.currentFlag {
                return Just(.rightAnswer).eraseToAnyPublisher()
            } else {
                return Just(.wrongAnswer(country)).eraseToAnyPublisher()
            }
            
        case .rightAnswer:
            state.scoreTitle = "Right!"
            state.score += 1
            state.showScore = true
            
        case let .wrongAnswer(country):
            state.scoreTitle = "Wrong! That the flag of: \(country)"
            state.showScore = true
            
        case .closeAlert:
            state.showScore = false
            state.showFinalScore = false
            
        case .showFinalScore:
            state.scoreTitle = "Game over! Your final score is: \(state.score)"
            state.showFinalScore = true
            
        case .restartGame:
            state.currentNumberOfQuestions = 0
            state.score = 0
            state.countries.shuffle()
            state.correctAnswer = .random(in: 0..<2)
            
        }
        return Empty().eraseToAnyPublisher()
    }
    
    //MARK: -  Preview store
    public static let previewStore = Store(
        state: Self.State(),
        reducer: Self.init())
}
