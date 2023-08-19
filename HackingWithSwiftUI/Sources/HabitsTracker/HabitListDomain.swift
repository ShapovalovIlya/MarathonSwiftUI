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
        case saveHabitsRequest
        case loadHabitsResponse([Habit])
        case removeHabitAtOffset(IndexSet)
        case updateHabit(Habit)
        case dismissAlert
        
        public static func == (lhs: HabitListDomain.Action, rhs: HabitListDomain.Action) -> Bool {
            String(describing: lhs) == String(describing: rhs)
        }
    }
    
    //MARK: - Dependencies
    private let loadHabits: ([Habit].Type) -> AnyPublisher<[Habit], Error>
    private let saveHabits: ([Habit]) throws -> Void
    
    //MARK: - init(_:)
    public init(
        loadHabits: @escaping ([Habit].Type) -> AnyPublisher<[Habit], Error> = UserDefaultsClient.shared.loadData,
        saveHabits: @escaping ([Habit]) throws -> Void = UserDefaultsClient.shared.saveModel
    ) {
        self.loadHabits = loadHabits
        self.saveHabits = saveHabits
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
                .replaceError(with: [])
                .map(Action.loadHabitsResponse)
                .eraseToAnyPublisher()
            
        case .saveHabitsRequest:
            logger.debug("Saving habits")
            do {
                try saveHabits(state.habits)
            } catch {
                state.isAlert = true
            }
            
        case let .loadHabitsResponse(habits):
            state.habits = habits
            
        case let .removeHabitAtOffset(offsets):
            state.habits.remove(atOffsets: offsets)
            return run(.saveHabitsRequest)
            
        case let .updateHabit(updatedHabit):
            addNew(updatedHabit)(&state.habits)
            return run(.saveHabitsRequest)
            
        case .dismissAlert:
            state.isAlert = false
        }
        
        return empty()
    }
    
    //MARK: - Preview store
    static let previewStore = Store(
        state: Self.State(),
        reducer: Self(
            loadHabits: { _ in
                Just(Habit.sample)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            },
            saveHabits: { _ in }
        )
    )
    
    //MARK: - Live store
    public static let liveStore = Store(
        state: Self.State(),
        reducer: Self()
    )
}

private extension HabitListDomain {
    func addNew(_ habit: Habit) -> (inout [Habit]) -> Void {
        {
            $0 = compose(
                removeHabit(withId: habit.id),
                insert(habit)
            )($0)
        }
    }
    
    func removeHabit(withId id: UUID) -> ([Habit]) -> [Habit] {
        { habits in
            habits.filter({ $0.id != id })
        }
    }
    
    func insert(_ habit: Habit) -> ([Habit]) -> [Habit] {
        { habits in
            var tmp = habits
            tmp.insert(habit, at: 0)
            return tmp
        }
    }
}
