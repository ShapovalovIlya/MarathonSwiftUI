//
//  HabitListDomain.swift
//  
//
//  Created by Илья Шаповалов on 18.08.2023.
//

import Foundation
import SwiftUDF
import Combine
import AppDependencies
import OSLog

public struct Habit: Codable {
    
    public init() {}
    
    static let sample: [Habit] = [
        .init(),
        .init(),
        .init()
    ]
}

public struct HabitListDomain: ReducerDomain {
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: Self.self)
    )
    
    //MARK: - State
    public struct State {
        
        public init() {}
    }
    
    //MARK: - Action
    public enum Action: Equatable {
        case viewAppeared
        case loadHabitsRequest
        case loadHabitsResponse(Result<[Habit], Error>)
        
        public static func == (lhs: HabitListDomain.Action, rhs: HabitListDomain.Action) -> Bool {
            String(describing: lhs) == String(describing: rhs)
        }
    }
    
    //MARK: - Dependencies
    private let loadHabits: ([Habit].Type) -> AnyPublisher<[Habit], Error>
    
    //MARK: - init(_:)
    public init(
        loadHabits: @escaping ([Habit].Type) -> AnyPublisher<[Habit], Error> = UserDefaultsClient.shared.loadData
    ) {
        self.loadHabits = loadHabits
    }
    
    //MARK: - Reducer
    public func reduce(_ state: inout State, action: Action) -> AnyPublisher<Action, Never> {
        switch action {
        case .viewAppeared:
            logger.debug("View appeared.")
            return run(.loadHabitsRequest)
            
        case .loadHabitsRequest:
            logger.debug("Request habits")
            return loadHabits([Habit].self)
                .map(transformToSuccessAction)
                .catch(catchToFailAction)
                .eraseToAnyPublisher()
            
        case let .loadHabitsResponse(.success(test)):
            break
            
        case let .loadHabitsResponse(.failure(error)):
            break
        }
        
        return empty()
    }
    
    //MARK: - Preview store
    static let previewStore = Store(
        state: Self.State(),
        reducer: Self(loadHabits: { _ in
            Just(Habit.sample)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        })
    )
    
    //MARK: - Live store
    public static let liveStore = Store(
        state: Self.State(),
        reducer: Self()
    )
}

private extension HabitListDomain {
    func transformToSuccessAction(_ habits: [Habit]) -> Action {
        .loadHabitsResponse(.success(habits))
    }
    
    func catchToFailAction(_ error: Error) -> AnyPublisher<Action, Never> {
        run(.loadHabitsResponse(.failure(error)))
    }
}
