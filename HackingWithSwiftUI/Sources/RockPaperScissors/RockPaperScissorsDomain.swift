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
        public var alertTitle: String
        public var score: Int
        public var isAlertShown: Bool
        
        //MARK: - init(_:)
        public init(
            playerWeapon: WeaponType = .allCases.randomElement() ?? .rock,
            enemyWeapon: WeaponType = .rock
        ) {
            self.playerWeapon = playerWeapon
            self.enemyWeapon = enemyWeapon
            self.alertTitle = .init()
            self.score = .init()
            self.isAlertShown = false
        }
    }
    
    //MARK: - Action
    public enum Action: Equatable {
        case setPlayerWeapon(WeaponType)
        case setEnemyWeapon(WeaponType)
        case getRandomEnemyWeapon
        case playRound
        case computeBattle
        case playerLose
        case playerWin
        case draw
    }
    
    //MARK: - Dependencies
    private var randomWeapon: () -> WeaponType
    
    //MARK: - init(_:)
    public init(
        randomWeapon: @escaping () -> WeaponType = { .allCases.randomElement() ?? .rock }
    ) {
        self.randomWeapon = randomWeapon
    }
    
    //MARK: - Reducer
    public func reduce(_ state: inout State, action: Action) -> AnyPublisher<Action, Never> {
        switch action {
        case let .setPlayerWeapon(weapon):
            state.playerWeapon = weapon
            return Just(.getRandomEnemyWeapon).eraseToAnyPublisher()
            
        case .getRandomEnemyWeapon:
            let weapon = randomWeapon()
            return Just(.setEnemyWeapon(weapon)).eraseToAnyPublisher()
            
        case let .setEnemyWeapon(weapon):
            state.enemyWeapon = weapon
            
        case .playRound:
            state.enemyWeapon = .allCases.randomElement() ?? .paper
            return Just(.computeBattle).eraseToAnyPublisher()
            
        case .computeBattle:
            if state.playerWeapon == state.enemyWeapon {
                return Just(.draw).eraseToAnyPublisher()
            }
            
            guard state.playerWeapon.weakness == state.enemyWeapon else {
                return Just(.playerWin).eraseToAnyPublisher()
            }
            return Just(.playerLose).eraseToAnyPublisher()
            
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
}
