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
import SwiftFP

public struct HabitListDomain: ReducerDomain {
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: Self.self)
    )
    
    //MARK: - State
    public struct State {
        public var habits: [Habit]
        public var isAlert: Bool
        
        public init(
            habits: [Habit] = .init(),
            isAlert: Bool = false
        ) {
            self.habits = habits
            self.isAlert = isAlert
        }
    }
    
    //MARK: - Action
    public enum Action: Equatable {
        case viewAppeared
        case loadHabitsRequest
        case loadHabitsResponse(Result<[Habit], Error>)
        case removeHabitAtOffset(IndexSet)
        case updateHabit(Habit)
        
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
            
        case let .loadHabitsResponse(.success(habits)):
            logger.debug("Load habits successful")
            state.habits = habits
            
        case let .loadHabitsResponse(.failure(error)):
            logger.error("Unable to load habits: \(error.localizedDescription)")
            state.isAlert = true
            
        case let .removeHabitAtOffset(offsets):
            state.habits.remove(atOffsets: offsets)
            
        case let .updateHabit(updatedHabit):
            state.habits = compose(
                removeDuplicate(updatedHabit),
                insert(updatedHabit)
            )(state.habits)
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
    
    func removeDuplicate(_ habit: Habit) -> ([Habit]) -> [Habit] {
        { habits in
            habits.filter({ $0.id != habit.id })
        }
    }
    
    func insert(_ habit: Habit) -> ([Habit]) -> [Habit] {
        { habits in
            var tmp = habits
            tmp.insert(habit, at: 0)
            return tmp
        }
    }
    
    func transformToSuccessAction(_ habits: [Habit]) -> Action {
        .loadHabitsResponse(.success(habits))
    }
    
    func catchToFailAction(_ error: Error) -> AnyPublisher<Action, Never> {
        run(.loadHabitsResponse(.failure(error)))
    }
}
