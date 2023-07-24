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
        
        //MARK: - init(_:)
        public init(
            sleepAmount: Double = 8,
            coffeeAmount: Int = .init(),
            alertTitle: String = .init(),
            alertMessage: String = .init()
        ) {
            self.sleepAmount = sleepAmount
            self.coffeeAmount = coffeeAmount
            self.alertTitle = alertTitle
            self.alertMessage = alertMessage
            
            var components = DateComponents()
            components.hour = 7
            components.minute = 0
            
            let defaultWakeTime = Calendar.current.date(from: components)
            
            self.wakeUp = defaultWakeTime ?? .now
            self.coffeeCupsTitle = coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups"
        }
    }
    
    //MARK: - Action
    public enum Action: Equatable {
        case setSleepAmount(Double)
        case setWakeUpDate(Date)
        case setCoffeeAmount(Int)
        case calculateSleep
        case calculateSleepResponse(Result<Date,Error>)
        
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
            return Just(.calculateSleep).eraseToAnyPublisher()
            
        case let .setWakeUpDate(date):
            state.wakeUp = date
            return Just(.calculateSleep).eraseToAnyPublisher()
            
        case let .setCoffeeAmount(coffeeAmount):
            state.coffeeAmount = coffeeAmount
            state.coffeeCupsTitle = coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups"
            return Just(.calculateSleep).eraseToAnyPublisher()
            
        case .calculateSleep:
            return predictSleep(state.wakeUp, state.sleepAmount, state.coffeeAmount)
                .map(transformToAction(_:))
                .catch(catchToAction(_:))
                .eraseToAnyPublisher()
            
        case let .calculateSleepResponse(.success(bedTime)):
            state.alertTitle = "Your ideal bedtime is…"
            state.alertMessage = bedTime.formatted(date: .omitted, time: .shortened)
            
        case let .calculateSleepResponse(.failure(error)):
            print(error)
            state.alertTitle = "Error"
            state.alertMessage = "Sorry, there was a problem calculating your bedtime."
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
