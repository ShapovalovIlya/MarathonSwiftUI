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
        public var score: Int
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
            self.score = .init()
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
            state.gameExpectation = expectationGenerator()
            state.enemyWeapon = weaponGenerator()
            
        case let .playerChooseWeapon(weapon):
            state.playerWeapon = weapon
            return Just(.playRound).eraseToAnyPublisher()
            
        case .playRound:
            return computeBattleResult(&state)
            
        case .playerWin:
            state.score += 1
            state.alertTitle = "You win!"
            state.isAlertShown = true
            
        case .playerLose:
            state.alertTitle = "You Lose!"
            state.isAlertShown = true
            guard state.score > 0 else {
                break
            }
            state.score -= 1
            
        case .draw:
            break
        }
        return Empty().eraseToAnyPublisher()
    }
    
    //MARK: - Preview Store
    public static let previewStore = Store(
        state: Self.State(),
        reducer: Self())
    
    //MARK: - Private
    private func computeBattleResult(_ state: inout State) -> AnyPublisher<Action, Never> {
        if state.playerWeapon == state.enemyWeapon {
            return Just(.draw).eraseToAnyPublisher()
        }
        guard state.playerWeapon.weakness == state.enemyWeapon else {
            return Just(.playerWin).eraseToAnyPublisher()
        }
        return Just(.playerLose).eraseToAnyPublisher()
    }
}
