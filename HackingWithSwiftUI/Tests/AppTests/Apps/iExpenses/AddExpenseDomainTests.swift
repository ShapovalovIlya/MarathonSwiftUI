//
//  AddExpenseDomainTests.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 05.08.2023.
//

import XCTest
import iExpense
import Shared

final class AddExpenseDomainTests: XCTestCase {
    private var sut: AddExpenseDomain!
    private var state: AddExpenseDomain.State!
    private var exp: XCTestExpectation!
    
    override func setUp() async throws {
        try await super.setUp()
        
        sut = .init()
        state = .init()
        exp = .init(description: "AddExpenseDomainTests")
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
    
    func test_setCurrency() {
        state.currency = ""
        
        _ = sut.reduce(&state, action: .setCurrency("Baz"))
        
        XCTAssertEqual(state.currency, "Baz")
    }
    
    func test_getExpenseItemFromState() {
        let testExpense = ExpenseItem(id: UUID(uuidString: "Bar") ?? .init(), name: "Baz", type: .personal, amount: 1, currency: "Baz")
        
        state.name = testExpense.name
        state.id = testExpense.id
        state.amount = testExpense.amount
        state.currency = testExpense.currency
        state.type = testExpense.type
        
        XCTAssertEqual(state.expense, testExpense)
    }
    
}
