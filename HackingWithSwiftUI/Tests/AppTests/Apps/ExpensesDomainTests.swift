//
//  ExpensesDomainTests.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 03.08.2023.
//

import XCTest
import iExpense
import Foundation
import Shared
import Combine

final class ExpensesDomainTests: XCTestCase {
    private var sut: ExpensesDomain!
    private var state: ExpensesDomain.State!
    private var exp: XCTestExpectation!
    private var testExpense: ExpenseItem!
    
    override func setUp() async throws {
        try await super.setUp()
        
        sut = .init()
        state = .init()
        exp = .init(description: "ExpensesDomainTests")
        testExpense = ExpenseItem(id: UUID(uuidString: "Bar") ?? .init(), name: "Baz", type: .personal, amount: 1)
    }
    
    override func tearDown() async throws {
        sut = nil
        state = nil
        exp = nil
        testExpense = nil
    }
    
    func test_reduceRemoveExpensesAtIndexSet() {
        state.expenses = [
            .init(name: "Baz", type: .business, amount: 1),
            testExpense
        ]
        
        _ = sut.reduce(&state, action: .removeExpense(testExpense))
        
        XCTAssertFalse(state.expenses.contains(testExpense))
    }
    
    func test_setExpenseName() {
        state.name = ""
        
        _ = sut.reduce(&state, action: .setExpenseName("Baz"))
        
        XCTAssertEqual(state.name, "Baz")
    }
    
    func test_setExpenseType() {
        state.type = .personal
        
        _ = sut.reduce(&state, action: .setExpenseType(.business))
        
        XCTAssertEqual(state.type, .business)
    }
    
    func test_setExpenseAmount() {
        state.amount = 0.0
        
        _ = sut.reduce(&state, action: .setExpenseAmount(1.0))
        
        XCTAssertEqual(state.amount, 1.0)
    }
    
    func test_reduceCloseAddExpenseSheet() {
        state.showingAddExpense = true
        
        _ = sut.reduce(&state, action: .closeAddExpenseSheet)
        
        XCTAssertFalse(state.showingAddExpense)
    }
    
    func test_reduceOpenAddExpenseSheet() {
        state.showingAddExpense = false
        
        _ = sut.reduce(&state, action: .openAddExpenseSheet)
        
        XCTAssertTrue(state.showingAddExpense)
    }
    
    func test_reduceSaveNewExpenseAction() {
        sut = .init(uuid: { self.testExpense.id })
        state.name = testExpense.name
        state.type = testExpense.type
        state.amount = testExpense.amount
        state.expenses = .init()
        
        _ = sut.reduce(&state, action: .saveButtonTap)
        
        XCTAssertEqual(state.expenses, [testExpense])
    }
    
    func test_reduceSaveButtonTapEmitSaveExpensesAction() {
        sut = .init(saveExpenses: { _ in })
        
        _ = sut.reduce(&state, action: .saveButtonTap)
            .sink(receiveValue: { [unowned self] action in
                exp.fulfill()
                XCTAssertEqual(action, .saveExpenses)
            })
        
        wait(for: [exp], timeout: 0.1)
    }
    
    func test_saveExpensesActionEndWithError() {
        let testError = URLError(.badURL)
        sut = .init(saveExpenses: { _ in throw testError })
        
        _ = sut.reduce(&state, action: .saveExpenses)
            .sink { [unowned self] action in
                exp.fulfill()
                XCTAssertEqual(action, .savingExpensesError(testError))
            }
        
        wait(for: [exp], timeout: 0.1)
    }
    
    func test_loadingExpensesEndWithSuccess() {
        let testCollection = [ExpenseItem(name: "Baz", type: .personal, amount: 1)]
        sut = .init(loadExpenses: {
            Just(testCollection)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        })
        
        _ = sut.reduce(&state, action: .viewAppeared)
            .sink(receiveValue: { [unowned self] action in
                exp.fulfill()
                XCTAssertEqual(action, .loadExpensesResponse(.success(testCollection)))
            })
        
        wait(for: [exp], timeout: 0.1)
    }
    
    func test_loadingExpensesEndWithError() {
        let testError = URLError(.badURL)
        sut = .init(loadExpenses: {
            Fail(error: testError)
                .eraseToAnyPublisher()
        })
        
        _ = sut.reduce(&state, action: .viewAppeared)
            .sink(receiveValue: { [unowned self] action in
                exp.fulfill()
                XCTAssertEqual(action, .loadExpensesResponse(.failure(testError)))
            })
        
        wait(for: [exp], timeout: 0.1)
    }

}
