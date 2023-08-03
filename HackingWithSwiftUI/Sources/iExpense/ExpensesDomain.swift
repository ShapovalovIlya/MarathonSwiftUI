//
//  ExpensesDomain.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 03.08.2023.
//

import Foundation
import SwiftUDF
import Combine
import AppDependencies
import Shared

public struct ExpensesDomain: ReducerDomain {
    //MARK: - State
    public struct State {
        public var expenses: [ExpenseItem]
        public var name: String
        public var type: ExpenseItem.ExpenseType
        public var amount: Double
        public var showingAddExpense: Bool
        
        public init(
            expenses: [ExpenseItem] = .init(),
            name: String = .init(),
            type: ExpenseItem.ExpenseType = .personal,
            amount: Double = .init(),
            showingAddExpense: Bool = false
        ) {
            self.expenses = expenses
            self.name = name
            self.type = type
            self.amount = amount
            self.showingAddExpense = showingAddExpense
        }
    }
    
    //MARK: - Action
    public enum Action: Equatable {
        case viewAppeared
        case loadExpensesResponse(Result<[ExpenseItem], Error>)
        case removeExpense(ExpenseItem)
        case setExpenseName(String)
        case setExpenseType(ExpenseItem.ExpenseType)
        case setExpenseAmount(Double)
        case closeAddExpenseSheet
        case openAddExpenseSheet
        case saveButtonTap
        case saveExpenses
        case savingExpensesError(Error)
        
        public static func == (lhs: ExpensesDomain.Action, rhs: ExpensesDomain.Action) -> Bool {
            String(describing: lhs) == String(describing: rhs)
        }
    }
    
    //MARK: - Dependencies
    private let uuid: () -> UUID
    private let saveExpenses: ([ExpenseItem]) throws -> Void
    private let loadExpenses: () -> AnyPublisher<[ExpenseItem], Error>
    
    //MARK: - init(_:)
    public init(
        uuid: @escaping () -> UUID = UUID.init,
        saveExpenses: @escaping ([ExpenseItem]) throws -> Void = UserDefaultsClient.shared.save(expenses:),
        loadExpenses: @escaping () -> AnyPublisher<[ExpenseItem], Error> = UserDefaultsClient.shared.loadExpenses
    ) {
        self.uuid = uuid
        self.saveExpenses = saveExpenses
        self.loadExpenses = loadExpenses
    }
    
    //MARK: - Reducer
    public func reduce(_ state: inout State, action: Action) -> AnyPublisher<Action, Never> {
        switch action {
        case .viewAppeared:
            return loadExpenses()
                .map(transformToSuccessAction(_:))
                .catch(catchToFailAction(_:))
                .eraseToAnyPublisher()
            
        case let .loadExpensesResponse(.success(expenses)):
            state.expenses = expenses
            
        case let .loadExpensesResponse(.failure(error)):
            print(error)
            
        case let .removeExpense(expense):
            state.expenses.removeAll(where: { $0.id == expense.id })
            return Just(.saveExpenses).eraseToAnyPublisher()
            
        case let .setExpenseName(name):
            state.name = name
            
        case let .setExpenseType(type):
            state.type = type
            
        case let .setExpenseAmount(amount):
            state.amount = amount
            
        case .closeAddExpenseSheet:
            state.showingAddExpense = false
            
        case .openAddExpenseSheet:
            state.showingAddExpense = true
            
        case .saveButtonTap:
            let newExpense = ExpenseItem(
                id: uuid(),
                name: state.name,
                type: state.type,
                amount: state.amount)
            
            state.expenses.append(newExpense)
            
            return Just(.saveExpenses).eraseToAnyPublisher()
            
        case .saveExpenses:
            do {
                try saveExpenses(state.expenses)
            } catch {
                return Just(.savingExpensesError(error))
                    .eraseToAnyPublisher()
            }
            
        case let .savingExpensesError(error):
            print(error.localizedDescription)
        }
        
        return Empty().eraseToAnyPublisher()
    }
    
    //MARK: - previewStore
    static let previewStore = Store(
        state: Self.State(expenses: ExpenseItem.sample),
        reducer: Self(
            saveExpenses: { _ in },
            loadExpenses: {
                Just(ExpenseItem.sample)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
        )
    )
    
    public static let liveStore = Store(
        state: Self.State(),
        reducer: Self()
    )
}

private extension ExpensesDomain {
    func transformToSuccessAction(_ expenses: [ExpenseItem]) -> Action {
        .loadExpensesResponse(.success(expenses))
    }
    
    func catchToFailAction(_ error: Error) -> Just<Action> {
        Just(.loadExpensesResponse(.failure(error)))
    }
}
