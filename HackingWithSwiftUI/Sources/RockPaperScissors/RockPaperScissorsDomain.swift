//
//  RockPaperScissorsDomain.swift
//  
//
//  Created by Илья Шаповалов on 21.07.2023.
//

import Foundation
import SwiftUDF
import Combine

public struct RockPaperScissorsDomain: ReducerDomain {
    //MARK: - State
    public struct State {
        public var playerWeapon: WeaponType
        public var enemyWeapon: WeaponType
        public var gameExpectation: GameExpectation
        public var alertTitle: String
        public var alertDescription: String
        public var score: Int
        public var currentRound: Int
        public var armory: [WeaponType]
        let maxRoundsCount: Int
        public var isAlertShown: Bool
        public var isPlayingGame: Bool
        
        //MARK: - init(_:)
        public init(
            playerWeapon: WeaponType = .rock,
            enemyWeapon: WeaponType = .rock,
            gameExpectation: GameExpectation = .draw,
            alertTitle: String = "Hello there!",
            alertDescription: String = "Let's play a game...",
            score: Int = .init(),
            currentRound: Int = .init(),
            isAlertShown: Bool = false,
            isPlayingGame: Bool = false
        ) {
            self.playerWeapon = playerWeapon
            self.enemyWeapon = enemyWeapon
            self.gameExpectation = gameExpectation
            self.alertTitle = alertTitle
            self.alertDescription = alertDescription
            self.score = score
            self.maxRoundsCount = 10
            self.currentRound = currentRound
            self.armory = WeaponType.allCases
            self.isAlertShown = isAlertShown
            self.isPlayingGame = isPlayingGame
        }
    }
    
    //MARK: - Action
    public enum Action: Equatable {
        case setupRound
        case playerChooseWeapon(WeaponType)
        case playRound
        case playerLose
        case playerWin
        case draw
        case expectationFulfill
        case expectationNotMatch
        case showGameResult(Bool)
        case gameOver
        case dismissAlert
    }
    
    //MARK: - Dependencies
    private var weaponGenerator: () -> WeaponType
    private var expectationGenerator: () -> GameExpectation
    
    //MARK: - init(_:)
    public init(
        weaponGenerator: @escaping () -> WeaponType = { WeaponType.allCases.randomElement() ?? .rock },
        expectationGenerator: @escaping () -> GameExpectation = { GameExpectation.allCases.randomElement() ?? .draw }
    ) {
        self.weaponGenerator = weaponGenerator
        self.expectationGenerator = expectationGenerator
    }
    
    //MARK: - Reducer
    public func reduce(_ state: inout State, action: Action) -> AnyPublisher<Action, Never> {
        switch action {
        case .setupRound:
            state.currentRound += 1
            state.gameExpectation = expectationGenerator()
            state.enemyWeapon = weaponGenerator()
            state.armory.shuffle()
            state.isPlayingGame = true
            
        case let .playerChooseWeapon(weapon):
            state.playerWeapon = weapon
            return Just(.playRound).eraseToAnyPublisher()
            
        case .playRound:
            return computeBattleResult(&state)
            
        case .playerWin:
            return reduce(state.gameExpectation, withResult: .playerWin)
            
        case .playerLose:
            return reduce(state.gameExpectation, withResult: .playerLoose)
            
        case .draw:
            return reduce(state.gameExpectation, withResult: .draw)
            
        case .expectationFulfill:
            return reduceGameFlow(state, isFulfill: true)
            
        case .expectationNotMatch:
            return reduceGameFlow(state, isFulfill: false)
            
        case let .showGameResult(result):
            reduce(&state, isFulfill: result)
            
        case .gameOver:
            state.alertTitle = "Game over!"
            state.alertDescription = "Your score is \(state.score) from 10"
            state.isAlertShown = false
            state.isPlayingGame = false
            state.currentRound = 0
            state.score = 0
            
        case .dismissAlert:
            state.isAlertShown = false
        }
        return Empty().eraseToAnyPublisher()
    }
    
    //MARK: - Preview Store
    public static let previewStore = Store(
        state: Self.State(),
        reducer: Self())
    
    static let previewStoreAlertState = Store(
        state: Self.State(alertTitle: "Right!", alertDescription: "Your score is 1", isAlertShown: true),
        reducer: Self())
    
    static let previewStoreGameOverState = Store(
        state: Self.State(alertTitle: "Game over!", alertDescription: "Your score is 1 from 10.", isPlayingGame: false),
        reducer: Self())
    
    static let previewStoreGameState = Store(
        state: Self.State(isPlayingGame: true),
        reducer: Self())
}

//MARK: - Private methods
private extension RockPaperScissorsDomain {
    private func computeBattleResult(_ state: inout State) -> AnyPublisher<Action, Never> {
        guard state.playerWeapon != state.enemyWeapon else {
            return Just(.draw).eraseToAnyPublisher()
        }
        guard state.playerWeapon.weakness == state.enemyWeapon else {
            return Just(.playerWin).eraseToAnyPublisher()
        }
        return Just(.playerLose).eraseToAnyPublisher()
    }
    
    private func reduce(
        _ expectations: GameExpectation,
        withResult result: GameExpectation
    ) -> AnyPublisher<Action, Never> {
        guard expectations == result else {
            return Just(.expectationNotMatch).eraseToAnyPublisher()
        }
        return Just(.expectationFulfill).eraseToAnyPublisher()
    }
    
    private func reduce(_ state: inout State, isFulfill: Bool) {
        switch isFulfill {
        case true:
            state.score += 1
            state.alertTitle = "Right!"
        case false:
            if state.score > 0 {
                state.score -= 1
            }
            state.alertTitle = "Wrong!"
        }
        state.alertDescription = "Your score: \(state.score)"
        state.isAlertShown = true
    }
    
    private func reduceGameFlow(_ state: State, isFulfill: Bool) -> AnyPublisher<Action, Never> {
        guard state.currentRound < state.maxRoundsCount else {
            return Just(.gameOver).eraseToAnyPublisher()
        }
        return Just(.showGameResult(isFulfill)).eraseToAnyPublisher()
    }
}
