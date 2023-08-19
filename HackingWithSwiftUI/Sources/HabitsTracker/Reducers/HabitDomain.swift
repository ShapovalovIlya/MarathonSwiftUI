//
//  HabitDomain.swift
//
//
//  Created by Илья Шаповалов on 19.08.2023.
//

import Foundation
import SwiftUDF
import Combine
import SwiftFP
import OSLog

public struct HabitDomain: ReducerDomain {
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: Self.self)
    )
    
    typealias Filter = (String) -> String
    //MARK: - State
    public typealias State = Habit
    
    //MARK: - Action
    public enum Action: Equatable {
        case setTitle(String)
        case setDescription(String)
        case incrementButtonTap
    }
    
    //MARK: - init(_:)
    public init() {}
    
    //MARK: - Reducer
    public func reduce(_ state: inout Habit, action: Action) -> AnyPublisher<Action, Never> {
        switch action {
        case let .setTitle(title):
            state.title = compose(
                trimWhiteSpaces(),
                trimNumbers()
            )(title)
            
        case let .setDescription(description):
            state.description = compose(
                trimWhiteSpaces(),
                trimillegalSymbols()
            )(description)
            
        case .incrementButtonTap:
            state.count += 1
        }
        return empty()
    }
    
    //MARK: - Live store
    static let liveStore = Store(
        state: Self.State(),
        reducer: Self()
    )
}

private extension HabitDomain {
    func trimWhiteSpaces() -> Filter {
        { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
    }
    
    func trimNumbers() -> Filter {
        { $0.trimmingCharacters(in: .decimalDigits) }
    }
    
    func trimillegalSymbols() -> Filter {
        { $0.trimmingCharacters(in: .illegalCharacters) }
    }
}
