//
//  TemperatureDomainTests.swift
//  
//
//  Created by User on 19.07.2023.
//

import Foundation
import XCTest
import Combine
import UnitConversions

final class TemperatureDomainTests: XCTestCase {
    private var sut: TemperatureDomain!
    private var state: TemperatureDomain.State!
    private var expectation: XCTestExpectation!
    
    override func setUp() async throws {
        try await super.setUp()
        
        self.sut = .init()
        self.state = .init(
            inputValueType: .celsius,
            outputValueType: .fahrenheit,
            inputTemperature: 0.0)
        self.expectation = .init()
    }
    
    override func tearDown() async throws {
        self.sut = nil
        self.state = nil
        
        try await super.tearDown()
    }
    
    func test_setInputTemperatureType() {
        _ = sut.reduce(&state, action: .setInputType(.fahrenheit))
        
        XCTAssertEqual(state.inputValueType, .fahrenheit)
    }
    
    func test_setInputTemperatureTypeEmitAction() {
        _ = sut.reduce(&state, action: .setInputType(.fahrenheit))
            .sink(receiveCompletion: { [unowned self] _ in
                expectation.fulfill()
            }, receiveValue: { action in
                XCTAssertEqual(action, .calculateTemperature)
            })
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_setOutputTemperatureType() {
        _ = sut.reduce(&state, action: .setOutputType(.celsius))
        
        XCTAssertEqual(state.outputValueType, .celsius)
    }
    
    func test_setOutputTemperatureTypeEmitAction() {
        _ = sut.reduce(&state, action: .setOutputType(.fahrenheit))
            .sink(receiveCompletion: { [unowned self] _ in
                expectation.fulfill()
            }, receiveValue: { action in
                XCTAssertEqual(action, .calculateTemperature)
            })
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_setInputValue() {
        _ = sut.reduce(&state, action: .setInputTemperature(2))
        
        XCTAssertEqual(state.inputTemperature, 2)
    }
    
    func test_setInputValueToZero() {
        _ = sut.reduce(&state, action: .setInputTemperature(0))
        
        XCTAssertEqual(state.temperatureResult, "Result value")
    }
    
    func test_setInputValueEmitAction() {
        _ = sut.reduce(&state, action: .setInputTemperature(2))
            .sink(receiveCompletion: { [unowned self] _ in
                expectation.fulfill()
            }, receiveValue: { action in
                XCTAssertEqual(action, .calculateTemperature)
            })
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_reduceCelsiusToKelvin() {
        state.inputValueType = .celsius
        state.outputValueType = .kelvin
        state.inputTemperature = 1
        
        _ = sut.reduce(&state, action: .calculateTemperature)
        
        XCTAssertEqual(state.temperatureResult, "274.2")
    }
    
    func test_reduceCelsiusToFarenheit() {
        state.inputValueType = .celsius
        state.outputValueType = .fahrenheit
        state.inputTemperature = 1
        
        _ = sut.reduce(&state, action: .calculateTemperature)
        
        XCTAssertEqual(state.temperatureResult, "33.8")
    }
    
    func test_reduceKelvinToCelsius() {
        state.inputValueType = .kelvin
        state.outputValueType = .celsius
        state.inputTemperature = 1
        
        _ = sut.reduce(&state, action: .calculateTemperature)
        
        XCTAssertEqual(state.temperatureResult, "-272.2")
    }
    
    func test_reduceKelvinToFarenheit() {
        state.inputValueType = .kelvin
        state.outputValueType = .fahrenheit
        state.inputTemperature = 1
        
        _ = sut.reduce(&state, action: .calculateTemperature)
        
        XCTAssertEqual(state.temperatureResult, "-457.9")
    }
    
    func test_reduceFarenheitToCelsius() {
        state.inputValueType = .fahrenheit
        state.outputValueType = .celsius
        state.inputTemperature = 1
        
        _ = sut.reduce(&state, action: .calculateTemperature)
        
        XCTAssertEqual(state.temperatureResult, "-17.2")

    }
    
    func test_reduceFarenheitToKelvin() {
        state.inputValueType = .fahrenheit
        state.outputValueType = .kelvin
        state.inputTemperature = 1
        
        _ = sut.reduce(&state, action: .calculateTemperature)
        
        XCTAssertEqual(state.temperatureResult, "255.9")

    }
}
