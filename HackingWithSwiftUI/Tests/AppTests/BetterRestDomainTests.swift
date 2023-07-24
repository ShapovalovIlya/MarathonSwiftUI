//
//  BetterRestDomainTests.swift
//  
//
//  Created by Илья Шаповалов on 23.07.2023.
//

import XCTest
import BetterRest
import Combine

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
    
    func test_calculateSleepActionEmitSuccess() {
        sut = .init(predictSleep: { _, _, _ in
            Just(.now)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        })
        
        _ = sut.reduce(&state, action: .calculateButtonTap)
            .sink(receiveValue: { [unowned self] action in
                expectation.fulfill()
                XCTAssertEqual(action, .calculateSleepResponse(.success(.now)))
            })
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_calculateSleepActionEmitError() {
        sut = .init(predictSleep: { _, _, _ in
            Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        })
        
        _ = sut.reduce(&state, action: .calculateButtonTap)
            .sink(receiveValue: { [unowned self] action in
                expectation.fulfill()
                XCTAssertEqual(action, .calculateSleepResponse(.failure(URLError(.badURL))))
            })
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_reduceSuccessSleepResponse() {
        _ = sut.reduce(&state, action: .calculateSleepResponse(.success(.now)))
        
        XCTAssertEqual(state.alertTitle, "Your ideal bedtime is…")
        XCTAssertEqual(state.alertMessage, Date.now.formatted(date: .omitted, time: .shortened))
        XCTAssertTrue(state.isAlertShown)
    }
    
    func test_reduceFailureSleepResponse() {
        _ = sut.reduce(&state, action: .calculateSleepResponse(.failure(URLError(.badURL))))
        
        XCTAssertEqual(state.alertTitle, "Error")
        XCTAssertEqual(state.alertMessage, "Sorry, there was a problem calculating your bedtime.")
        XCTAssertTrue(state.isAlertShown)
    }
    
    func test_reduceDismissAlertAction() {
        state.isAlertShown = true
        
        _ = sut.reduce(&state, action: .dismissAlert)
        
        XCTAssertFalse(state.isAlertShown)
    }

}
