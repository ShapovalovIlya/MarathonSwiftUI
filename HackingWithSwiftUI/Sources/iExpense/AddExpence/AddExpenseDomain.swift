//
//  AddExpenseDomain.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 05.08.2023.
//

import Foundation
import SwiftUDF
import Combine
import Shared

public struct AddExpenseDomain: ReducerDomain {
    //MARK: - State
    public struct State {
        public var id: UUID
        public var name: String
        public var amount: Double
        public var currency: String
        public var type: ExpenseItem.ExpenseType
        
        public var expense: ExpenseItem {
            .init(id: id, name: name, type: type, amount: amount, currency: currency)
        }
        
        public init(
            id: UUID = .init(),
            name: String = .init(),
            amount: Double = .init(),
            currency: String = Locale.current.currency?.identifier ?? "USD",
            type: ExpenseItem.ExpenseType = .personal
        ) {
            self.id = id
            self.name = name
            self.currency = currency
            self.amount = amount
            self.type = type
        }
    }
    
    //MARK: - Action
    public enum Action: Equatable {
        case setExpenseName(String)
        case setExpenseType(ExpenseItem.ExpenseType)
        case setExpenseAmount(Double)
        case setCurrency(String)
    }
    
    //MARK: - init(_:)
    public init() {}
    
    //MARK: - Reducer
    public func reduce(_ state: inout State, action: Action) -> AnyPublisher<Action, Never> {
        switch action {
        case let .setExpenseName(name):
            state.name = name
            
        case let .setExpenseType(type):
            state.type = type
            
        case let .setExpenseAmount(amount):
            state.amount = amount
            
        case let .setCurrency(currency):
            state.currency = currency
        }
        return Empty().eraseToAnyPublisher()
    }
    
    //MARK: - Preview store
    static let previewStore = Store(
        state: Self.State(),
        reducer: Self()
    )
}
