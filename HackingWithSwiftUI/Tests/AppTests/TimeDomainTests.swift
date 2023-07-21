//
//  TimeDomainTests.swift
//  
//
//  Created by User on 19.07.2023.
//

import XCTest
import UnitConversions
import Combine

final class TimeDomainTests: XCTestCase {
    private var sut: TimeDomain!
    private var state: TimeDomain.State!
    private var expectation: XCTestExpectation!
    
    override func setUp() async throws {
        try await super.setUp()
        
        sut = .init()
        state = .init(
            inputTime: 0,
            resultTime: "0",
            inputValueType: .seconds,
            outputValueType: .minutes)
        expectation = .init()
    }
    
    override func tearDown() async throws {
        sut = nil
        state = nil
        expectation = nil
        
        try await super.tearDown()
    }
    
    func test_setInputValue() {
        _ = sut.reduce(&state, action: .setInputTime(1))
        
        XCTAssertEqual(state.inputTime, 1.0)
    }
    
    func test_setInputValueToZero() {
        _ = sut.reduce(&state, action: .setInputTime(0))
        
        XCTAssertEqual(state.resultTime, "Result value")
    }
    
    func test_setInputType() {
        _ = sut.reduce(&state, action: .setInputType(.milliseconds))
        
        XCTAssertEqual(state.inputValueType, .milliseconds)
    }
    
    func test_setOutputType() {
        _ = sut.reduce(&state, action: .setOutputType(.hours))
        
        XCTAssertEqual(state.outputValueType, .hours)
    }
    
    func test_setInputValueEmitAction() {
        _ = sut.reduce(&state, action: .setInputTime(1))
            .sink(receiveCompletion: { [unowned self] _ in
                expectation.fulfill()
            }, receiveValue: { action in
                XCTAssertEqual(action, .computeValue)
            })
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_setInputTypeEmitAction() {
        _ = sut.reduce(&state, action: .setInputType(.milliseconds))
            .sink(receiveCompletion: { [unowned self] _ in
                expectation.fulfill()
            }, receiveValue: { action in
                XCTAssertEqual(action, .computeValue)
            })
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_setOutputTypeEmitAction() {
        _ = sut.reduce(&state, action: .setOutputType(.milliseconds))
            .sink(receiveCompletion: { [unowned self] _ in
                expectation.fulfill()
            }, receiveValue: { action in
                XCTAssertEqual(action, .computeValue)
            })
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_reduceSecondsToMinutes() {
        state.inputValueType = .seconds
        state.outputValueType = .minutes
        state.inputTime = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultTime, "0.016667")
    }
    
    func test_reduceSecondsToHours() {
        state.inputValueType = .seconds
        state.outputValueType = .hours
        state.inputTime = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultTime, "0.000278")
    }
    
    func test_reduceSecondsToMilliseconds() {
        state.inputValueType = .seconds
        state.outputValueType = .milliseconds
        state.inputTime = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultTime, "1,000")
    }
    
    func test_reduceMillisecondsToSeconds() {
        state.inputValueType = .milliseconds
        state.outputValueType = .seconds
        state.inputTime = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultTime, "0.001")
    }
    
    func test_reduceMillisecondsToMinutes() {
        state.inputValueType = .milliseconds
        state.outputValueType = .minutes
        state.inputTime = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultTime, "0.000017")
    }
    
    func test_reduceMillisecondsToHours() {
        state.inputValueType = .milliseconds
        state.outputValueType = .hours
        state.inputTime = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultTime, "0")
    }
    
    func test_reduceMinutesToMilliseconds() {
        state.inputValueType = .minutes
        state.outputValueType = .milliseconds
        state.inputTime = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultTime, "60,000")
    }
    
    func test_reduceMinutesToSeconds() {
        state.inputValueType = .minutes
        state.outputValueType = .seconds
        state.inputTime = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultTime, "60")
    }
    
    func test_reduceMinutesToHours() {
        state.inputValueType = .minutes
        state.outputValueType = .hours
        state.inputTime = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultTime, "0.016667")
    }
    
    func test_reduceHoursToMilliseconds() {
        state.inputValueType = .hours
        state.outputValueType = .milliseconds
        state.inputTime = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultTime, "3,600,000")
    }
    
    func test_reduceHoursToSeconds() {
        state.inputValueType = .hours
        state.outputValueType = .seconds
        state.inputTime = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultTime, "3,600")
    }
    
    func test_reduceHoursToMinutes() {
        state.inputValueType = .hours
        state.outputValueType = .minutes
        state.inputTime = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultTime, "60")
    }
}
