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
        public var alertTitle: String
        public var alertMessage: String
        public var isAlertShown: Bool
        
        //MARK: - init(_:)
        public init(
            sleepAmount: Double = 8,
            wakeUp: Date = .init(),
            coffeeAmount: Int = .init(),
            coffeeCupsTitle: String = .init(),
            alertTitle: String = .init(),
            alertMessage: String = .init(),
            isAlertShown: Bool = false
        ) {
            self.sleepAmount = sleepAmount
            self.wakeUp = wakeUp
            self.coffeeAmount = coffeeAmount
            self.coffeeCupsTitle = coffeeCupsTitle
            self.alertTitle = alertTitle
            self.alertMessage = alertMessage
            self.isAlertShown = isAlertShown
        }
    }
    
    //MARK: - Action
    public enum Action: Equatable {
        case setSleepAmount(Double)
        case setWakeUpDate(Date)
        case setCoffeeAmount(Int)
        case calculateButtonTap
        case calculateSleepResponse(Result<Date,Error>)
        case dismissAlert
        
        public static func == (lhs: BetterRestDomain.Action, rhs: BetterRestDomain.Action) -> Bool {
            String(describing: lhs) == String(describing: rhs)
        }
    }
    
    //MARK: - Dependency
    private let predictSleep: (_ wakeUp: Date, _ sleep: Double, _ coffee: Int) -> AnyPublisher<Date, Error>
    
    //MARK: - init(_:)
    public init(
        predictSleep: @escaping (_ wakeUp: Date, _ sleep: Double, _ coffee: Int) -> AnyPublisher<Date, Error> = SleepCalculatorService.predictSleep
    ) {
        self.predictSleep = predictSleep
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
            return predictSleep(state.wakeUp, state.sleepAmount, state.coffeeAmount)
                .map(transformToAction(_:))
                .catch(catchToAction(_:))
                .eraseToAnyPublisher()
            
        case let .calculateSleepResponse(.success(bedTime)):
            state.alertTitle = "Your ideal bedtime is…"
            state.alertMessage = bedTime.formatted(date: .omitted, time: .shortened)
            state.isAlertShown = true
            
        case let .calculateSleepResponse(.failure(error)):
            print(error)
            state.alertTitle = "Error"
            state.alertMessage = "Sorry, there was a problem calculating your bedtime."
            state.isAlertShown = true
            
        case .dismissAlert:
            state.isAlertShown = false
            
        }
        return Empty().eraseToAnyPublisher()
    }
    
    //MARK: - Preview Store
    static let previewStore = Store(
        state: Self.State(),
        reducer: Self())
}

private extension BetterRestDomain {
    func transformToAction(_ sleepDate: Date) -> Action {
        .calculateSleepResponse(.success(sleepDate))
    }
    
    func catchToAction(_ error: Error) -> AnyPublisher<Action, Never> {
        Just(Action.calculateSleepResponse(.failure(error)))
            .eraseToAnyPublisher()
    }
}
