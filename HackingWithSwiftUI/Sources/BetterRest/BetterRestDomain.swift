//
//  BetterRestDomain.swift
//  
//
//  Created by Илья Шаповалов on 23.07.2023.
//

import Foundation
import Combine
import SwiftUDF

public struct BetterRestDomain: ReducerDomain {
    //MARK: - State
    public struct State {
        public var sleepAmount: Double
        public var wakeUp: Date
        public var coffeeAmount: Int
        public var coffeeCupsTitle: String
        
        //MARK: - init(_:)
        public init(
            sleepAmount: Double = 8,
            wakeUp: Date = .init(),
            coffeeAmount: Int = .init(),
            coffeeCupsTitle: String = .init()
        ) {
            self.sleepAmount = sleepAmount
            self.wakeUp = wakeUp
            self.coffeeAmount = coffeeAmount
            self.coffeeCupsTitle = coffeeCupsTitle
        }
    }
    
    //MARK: - Action
    public enum Action {
        case setSleepAmount(Double)
        case setWakeUpDate(Date)
        case setCoffeeAmount(Int)
        case calculateButtonTap
        case calculateSleepResponse(Result<String,Error>)
    }
    
    //MARK: - Dependency
    private let sleepCalculator: SleepCalculatorService
    
    //MARK: - init(_:)
    public init(sleepCalculator: SleepCalculatorService = .live) {
        self.sleepCalculator = sleepCalculator
    }
    
    //MARK: - Reducer
    public func reduce(_ state: inout State, action: Action) -> AnyPublisher<Action, Never> {
        switch action {
        case let .setSleepAmount(sleepAmount):
            state.sleepAmount = sleepAmount
            
        case let .setWakeUpDate(date):
            state.wakeUp = date
            
        case let .setCoffeeAmount(coffeeAmount):
            state.coffeeAmount = coffeeAmount
            state.coffeeCupsTitle = coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups"
            
        case .calculateButtonTap:
            return sleepCalculator
                .predictSleep(state.wakeUp, state.sleepAmount, state.coffeeAmount)
                .map(transformToAction(_:))
                .catch(catchToAction(_:))
                .eraseToAnyPublisher()
            
        case let .calculateSleepResponse(.success(bedTime)):
            break
            
        case let .calculateSleepResponse(.failure(error)):
            break
            
        }
        return Empty().eraseToAnyPublisher()
    }
    
    //MARK: - Preview Store
    static let previewStore = Store(
        state: Self.State(),
        reducer: Self())
}

private extension BetterRestDomain {
    func transformToAction(_ success: String) -> Action {
        .calculateSleepResponse(.success(success))
    }
    
    func catchToAction(_ error: Error) -> AnyPublisher<Action, Never> {
        Just(Action.calculateSleepResponse(.failure(error)))
            .eraseToAnyPublisher()
    }
}
