//
//  File.swift
//  
//
//  Created by User on 19.07.2023.
//

import XCTest
import Combine
import UnitConversions

final class LenghtDomainTests: XCTestCase {
    private var sut: LenghtDomain!
    private var state: LenghtDomain.State!
    private var expectation: XCTestExpectation!
    
    override func setUp() async throws {
        try await super.setUp()
        
        sut = .init()
        state = .init(
            inputLenght: 0,
            resultLenght: "",
            inputValueType: .meters,
            outputValueType: .kilometers)
        expectation = .init()
    }
    
    override func tearDown() async throws {
        sut = nil
        state = nil
        expectation = nil
        
        try await super.tearDown()
    }
    
    func test_setInputType() {
        _ = sut.reduce(&state, action: .setInputType(.feet))
        
        XCTAssertEqual(state.inputValueType, .feet)
    }
    
    func test_setOutputType() {
        _ = sut.reduce(&state, action: .setOutputType(.yards))
        
        XCTAssertEqual(state.outputValueType, .yards)
    }
    
    func test_setInputLenght() {
        _ = sut.reduce(&state, action: .setInputLength(1))
        
        XCTAssertEqual(state.inputLength, 1.0)
    }
    
    func test_setInputValueToZero() {
        _ = sut.reduce(&state, action: .setInputLength(0))
        
        XCTAssertEqual(state.resultLength, "Result value")
    }
    
    func test_reduceInputTypeEmitAction() {
        _ = sut.reduce(&state, action: .setInputType(.feet))
            .sink(receiveCompletion: { [unowned self] _ in
                expectation.fulfill()
            }, receiveValue: { action in
                XCTAssertEqual(action, .computeValue)
            })
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_reduceOutputTypeEmitAction() {
        _ = sut.reduce(&state, action: .setOutputType(.feet))
            .sink(receiveCompletion: { [unowned self] _ in
                expectation.fulfill()
            }, receiveValue: { action in
                XCTAssertEqual(action, .computeValue)
            })
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_reduceInputLenght() {
        _ = sut.reduce(&state, action: .setInputLength(0))
            .sink(receiveCompletion: { [unowned self] _ in
                expectation.fulfill()
            }, receiveValue: { action in
                XCTAssertEqual(action, .computeValue)
            })
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_reduceMetersToKilometers() {
        state.inputValueType = .meters
        state.outputValueType = .kilometers
        state.inputLength = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultLength, "0.001")
    }
    
    func test_reduceMetersToFeet() {
        state.inputValueType = .meters
        state.outputValueType = .feet
        state.inputLength = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultLength, "3.281")
    }
    
    func test_reduceMetersToMiles() {
        state.inputValueType = .meters
        state.outputValueType = .miles
        state.inputLength = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultLength, "0.001")
    }
    
    func test_reduceMetersToYards() {
        state.inputValueType = .meters
        state.outputValueType = .yards
        state.inputLength = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultLength, "1.094")
    }
    
    func test_reduceKilometersToMeters() {
        state.inputValueType = .kilometers
        state.outputValueType = .meters
        state.inputLength = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultLength, "1,000")
    }
    
    func test_reduceKilometersToFeet() {
        state.inputValueType = .kilometers
        state.outputValueType = .feet
        state.inputLength = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultLength, "3,280.84")
    }
    
    func test_reduceKilometersToMiles() {
        state.inputValueType = .kilometers
        state.outputValueType = .miles
        state.inputLength = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultLength, "0.621")
    }
    
    func test_reduceKilometersToYards() {
        state.inputValueType = .kilometers
        state.outputValueType = .yards
        state.inputLength = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultLength, "1,093.613")
    }
    
    func test_reduceMilesToYards() {
        state.inputValueType = .miles
        state.outputValueType = .yards
        state.inputLength = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultLength, "1,760")
    }
    
    func test_reduceMilesToFeet() {
        state.inputValueType = .miles
        state.outputValueType = .feet
        state.inputLength = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultLength, "5,280")
    }
    
    func test_reduceMilesToKilometers() {
        state.inputValueType = .miles
        state.outputValueType = .kilometers
        state.inputLength = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultLength, "1.609")
    }
    
    func test_reduceMilesToMeters() {
        state.inputValueType = .miles
        state.outputValueType = .meters
        state.inputLength = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultLength, "1,609.344")
    }
    
    func test_reduceFeetToMeter() {
        state.inputValueType = .feet
        state.outputValueType = .meters
        state.inputLength = 1

        _ = sut.reduce(&state, action: .computeValue)

        XCTAssertEqual(state.resultLength, "0.305")
    }
    
    func test_reduceFeetToYards() {
        state.inputValueType = .feet
        state.outputValueType = .yards
        state.inputLength = 1

        _ = sut.reduce(&state, action: .computeValue)

        XCTAssertEqual(state.resultLength, "0.333")
    }
    
    func test_reduceFeetToMiles() {
        state.inputValueType = .feet
        state.outputValueType = .miles
        state.inputLength = 1

        _ = sut.reduce(&state, action: .computeValue)

        XCTAssertEqual(state.resultLength, "0")
    }
    
    func test_reduceFeetToKilometers() {
        state.inputValueType = .feet
        state.outputValueType = .kilometers
        state.inputLength = 1

        _ = sut.reduce(&state, action: .computeValue)

        XCTAssertEqual(state.resultLength, "0")
    }
}
