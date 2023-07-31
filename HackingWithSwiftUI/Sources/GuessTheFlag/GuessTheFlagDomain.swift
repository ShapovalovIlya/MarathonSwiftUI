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
        public var score: Int
        public var countries: [String]
        public var showScore: Bool
        public var showFinalScore: Bool
        public var scoreTitle: String
        public var currentNumberOfQuestions: Int
        public var totalQuestions: Int
        public var correctAnswer: Int
        public var currentFlag: String {
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
    
    //MARK: - Dependencies
    private var scheduler: RunLoop
    private var randomInt: () -> Int
    private var shuffler: ([String]) -> [String]
    
    //MARK: - init(_:)
    public init(
        scheduler: RunLoop = .main,
        randomInt: @escaping () -> Int = { .random(in: 0..<2) },
        shuffler: @escaping ([String]) -> [String] = { $0.shuffled() }
    ) {
        self.scheduler = scheduler
        self.randomInt = randomInt
        self.shuffler = shuffler
    }
    
    //MARK: - Reducer
    public func reduce(_ state: inout State, action: Action) -> AnyPublisher<Action, Never> {
        switch action {
        case .askQuestion:
            guard state.currentNumberOfQuestions <= 8 else {
                return Just(.showFinalScore).eraseToAnyPublisher()
            }
            state.countries = shuffler(state.countries)
            state.correctAnswer = randomInt()
            state.currentNumberOfQuestions += 1
            
        case let .tapOnFlag(country):
            return Publishers.Zip(
                Just(country),
                Just(state.currentFlag)
            )
            .map(compare(guess:truth:))
            .delay(for: .milliseconds(1500), scheduler: scheduler)
            .eraseToAnyPublisher()
                  
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
            state.countries = shuffler(state.countries)
            state.correctAnswer = randomInt()
            
        }
        return Empty().eraseToAnyPublisher()
    }
    
    //MARK: - Private methods
    private func compare(guess: String, truth: String) -> Action {
        guard guess == truth else {
            return .wrongAnswer(guess)
        }
        return .rightAnswer
    }
    
    //MARK: -  Preview store
    public static let previewStore = Store(
        state: Self.State(),
        reducer: Self.init())
}
