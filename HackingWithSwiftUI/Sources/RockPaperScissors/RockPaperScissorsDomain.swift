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
        let totalRounds: Int
        public var isAlertShown: Bool
        
        //MARK: - init(_:)
        public init(
            playerWeapon: WeaponType = .allCases.randomElement() ?? .rock,
            enemyWeapon: WeaponType = .rock,
            gameExpectation: GameExpectation = .draw
        ) {
            self.playerWeapon = playerWeapon
            self.enemyWeapon = enemyWeapon
            self.gameExpectation = gameExpectation
            self.alertTitle = .init()
            self.alertDescription = .init()
            self.score = .init()
            self.totalRounds = 10
            self.currentRound = 0
            self.isAlertShown = false
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
            return Just(.showGameResult(true)).eraseToAnyPublisher()
            
        case .expectationNotMatch:
            return Just(.showGameResult(false)).eraseToAnyPublisher()
            
        case let .showGameResult(result):
            reduce(&state, isFulfill: result)
            
        }
        return Empty().eraseToAnyPublisher()
    }
    
    //MARK: - Preview Store
    public static let previewStore = Store(
        state: Self.State(),
        reducer: Self())
}

//MARK: - Private methods
private extension RockPaperScissorsDomain {
    private func computeBattleResult(_ state: inout State) -> AnyPublisher<Action, Never> {
        if state.playerWeapon == state.enemyWeapon {
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
}
