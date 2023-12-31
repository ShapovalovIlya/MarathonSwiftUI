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
        public var isShowSheet: Bool
        public let key = "habits"
        
        public init(
            habits: [Habit] = .init(),
            isAlert: Bool = false,
            isShowSheet: Bool = false
        ) {
            self.habits = habits
            self.isAlert = isAlert
            self.isShowSheet = isShowSheet
        }
    }
    
    //MARK: - Action
    public enum Action: Equatable {
        case viewAppeared
        case loadHabitsRequest
        case saveHabitsRequest
        case loadHabitsResponse([Habit])
        case removeHabitAtOffset(IndexSet)
        case moveHabit(from: IndexSet, to: Int)
        case updateHabit(Habit)
        case dismissAlert
        case dismissSheet
        case addHabitButtonTap
        
        public static func == (lhs: HabitListDomain.Action, rhs: HabitListDomain.Action) -> Bool {
            String(describing: lhs) == String(describing: rhs)
        }
    }
    
    //MARK: - Dependencies
    private let loadHabits: (String) -> AnyPublisher<[Habit], Error>
    private let saveHabits: ([Habit], String) throws -> Void
    
    //MARK: - init(_:)
    public init(
        loadHabits: @escaping (String) -> AnyPublisher<[Habit], Error> = UserDefaultsClient.shared.loadData,
        saveHabits: @escaping ([Habit], String) throws -> Void = UserDefaultsClient.shared.saveModel
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
            return loadHabits(state.key)
                .replaceError(with: [])
                .map(Action.loadHabitsResponse)
                .eraseToAnyPublisher()
            
        case .saveHabitsRequest:
            logger.debug("Saving habits")
            do {
                try saveHabits(state.habits, state.key)
            } catch {
                state.isAlert = true
            }
            
        case let .loadHabitsResponse(habits):
            logger.debug("Loaded \(habits.count) habits")
            state.habits = habits
            
        case let .removeHabitAtOffset(offsets):
            state.habits.remove(atOffsets: offsets)
            return run(.saveHabitsRequest)
            
        case let .moveHabit(from: offsets, to: index):
            state.habits.move(fromOffsets: offsets, toOffset: index)
            
        case let .updateHabit(updatedHabit):
            addNew(updatedHabit)(&state.habits)
            return run(.saveHabitsRequest)
            
        case .dismissAlert:
            state.isAlert = false
            
        case .dismissSheet:
            state.isShowSheet = false
            
        case .addHabitButtonTap:
            state.isShowSheet = true
        }
        
        return empty()
    }
    
    //MARK: - Preview store
    public static let previewStore = Store(
        state: Self.State(),
        reducer: Self(
            loadHabits: { _ in
                Just(Habit.sample)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            },
            saveHabits: { _,_  in }
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
