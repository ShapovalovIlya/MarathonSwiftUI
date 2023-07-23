//
//  BetterRestDomainTests.swift
//  
//
//  Created by Илья Шаповалов on 23.07.2023.
//

import XCTest
import BetterRest

final class BetterRestDomainTests: XCTestCase {
    private var sut: BetterRestDomain!
    private var state: BetterRestDomain.State!
    private var expectation: XCTestExpectation!
    
    override func setUp() async throws {
        try await super.setUp()
        
        sut = .init()
        state = .init(sleepAmount: 0)
        expectation = .init(description: "BetterRestDomainTests")
    }
    
    override func tearDown() async throws {
        sut = nil
        state = nil
        expectation = nil
        
        try await super.tearDown()
    }
    
    func test_reduceSetSleepAmount() {
        _ = sut.reduce(&state, action: .setSleepAmount(1))
        
        XCTAssertEqual(state.sleepAmount, 1)
    }
    
    func test_reduceSetWakeUp() {
        let expectedDate: Date = .init(timeIntervalSince1970: 1)
        
        _ = sut.reduce(&state, action: .setWakeUpDate(expectedDate))
        
        XCTAssertEqual(state.wakeUp, expectedDate)
    }
    
    func test_reduceSetCoffeeAmount() {
        _ = sut.reduce(&state, action: .setCoffeeAmount(1))
        
        XCTAssertEqual(state.coffeeAmount, 1)
    }
    
    func test_reduceSetCoffeeSetCoffeeCupTitle() {
        _ = sut.reduce(&state, action: .setCoffeeAmount(1))
        
        XCTAssertEqual(state.coffeeCupsTitle, "1 cup")
    }
    
    func test_reduceSetCoffeeSetCoffeeCupsTitle() {
        _ = sut.reduce(&state, action: .setCoffeeAmount(2))
        
        XCTAssertEqual(state.coffeeCupsTitle, "2 cups")
    }
    
    

}
