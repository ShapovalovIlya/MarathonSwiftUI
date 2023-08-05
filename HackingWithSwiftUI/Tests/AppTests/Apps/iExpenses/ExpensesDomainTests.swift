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
    private var testCollection: [ExpenseItem]!
    
    override func setUp() async throws {
        try await super.setUp()
        
        sut = .init()
        state = .init()
        exp = .init(description: "ExpensesDomainTests")
        testExpense = ExpenseItem(id: UUID(uuidString: "Bar") ?? .init(), name: "Baz", type: .personal, amount: 1, currency: "Baz")
        testCollection = [
            ExpenseItem(name: "Baz", type: .personal, amount: 1, currency: "Bar"),
            ExpenseItem(name: "Bar", type: .business, amount: 1, currency: "Foo")
        ]
    }
    
    override func tearDown() async throws {
        sut = nil
        state = nil
        exp = nil
        testExpense = nil
        testCollection = nil
    }
    
    func test_reduceRemoveExpensesAtIndexSet() {
        state.expenses = [
            .init(name: "Baz", type: .business, amount: 1, currency: "Bar"),
            testExpense
        ]
        
        _ = sut.reduce(&state, action: .removeExpense(testExpense))
        
        XCTAssertFalse(state.expenses.contains(testExpense))
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
        state.expenses = .init()
        
        _ = sut.reduce(&state, action: .addExpense(testExpense))
        
        XCTAssertEqual(state.expenses, [testExpense])
    }
    
    func test_reduceSaveButtonTapEmitSaveExpensesAction() {
        sut = .init(saveExpenses: { _ in })
        
        _ = sut.reduce(&state, action: .addExpense(testExpense))
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
        sut = .init(loadExpenses: { [unowned self] in
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
    
    func test_reduceSuccessLoadedExpenses() {
        state.expenses = .init()
        
        _ = sut.reduce(&state, action: .loadExpensesResponse(.success(testCollection)))
        
        XCTAssertEqual(state.expenses, testCollection)
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
    
    func test_returnPersonalExpenses() {
        state.expenses = testCollection
        
        XCTAssertEqual(
            state.personalExpenses,
            testCollection.filter({ $0.type == .personal })
        )
    }
    
    func test_returnBusinessExpenses() {
        state.expenses = testCollection
        
        XCTAssertEqual(
            state.businessExpenses,
            testCollection.filter({ $0.type == .business })
        )
    }

}
