//
//  VolumeDomainTests.swift
//  
//
//  Created by User on 20.07.2023.
//

import XCTest
import UnitConversions
import Combine

private final class VolumeDomainTests: XCTestCase {
    private var sut: VolumeDomain!
    private var state: VolumeDomain.State!
    private var expectation: XCTestExpectation!
    
    override func setUp() async throws {
        try await super.setUp()
        
        sut = .init()
        state = .init(
            inputVolume: 0,
            resultVolume: "0",
            inputValueType: .milliliters,
            outputValueType: .liters)
        expectation = .init(description: "VolumeDomainTests expectation")
    }
    
    override func tearDown() async throws {
        sut = nil
        state = nil
        expectation = nil
        
        try await super.tearDown()
    }
    
    func test_setInputVolume() {
        _ = sut.reduce(&state, action: .setInputVolume(1))
        
        XCTAssertEqual(state.inputVolume, 1)
    }
    
    func test_setInputValueType() {
        _ = sut.reduce(&state, action: .setInputType(.cups))
        
        XCTAssertEqual(state.inputValueType, .cups)
    }
    
    func test_setOutputValueType() {
        _ = sut.reduce(&state, action: .setOutputType(.cups))
        
        XCTAssertEqual(state.outputValueType, .cups)
    }
    
    func test_inputValueIsZero() {
        _ = sut.reduce(&state, action: .setInputVolume(0))
        
        XCTAssertEqual(state.resultVolume, "Result value")
    }
    
    func test_setVolumeEmitComputeAction() {
        _ = sut.reduce(&state, action: .setInputVolume(1))
            .sink(receiveValue: { [unowned self] action in
                XCTAssertEqual(action, .computeValue)
                expectation.fulfill()
            })
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_setInputTypeEmitComputeAction() {
        _ = sut.reduce(&state, action: .setInputType(.cups))
            .sink(receiveValue: { [unowned self] action in
                XCTAssertEqual(action, .computeValue)
                expectation.fulfill()
            })
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_setOutputTypeEmitComputeAction() {
        _ = sut.reduce(&state, action: .setOutputType(.cups))
            .sink(receiveValue: { [unowned self] action in
                XCTAssertEqual(action, .computeValue)
                expectation.fulfill()
            })
        wait(for: [expectation], timeout: 0.1)
    }
    
    //MARK: - Milliliters
    func test_reduceMillilitersToLiters() {
        state.inputValueType = .milliliters
        state.outputValueType = .liters
        state.inputVolume = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultVolume, "0.001")
    }
    
    func test_reduceMillilitersToCups() {
        state.inputValueType = .milliliters
        state.outputValueType = .cups
        state.inputVolume = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultVolume, "0.004")
    }
    
    func test_reduceMillilitersToGallons() {
        state.inputValueType = .milliliters
        state.outputValueType = .gallons
        state.inputVolume = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultVolume, "0")
    }
    
    func test_reduceMillilitersToPints() {
        state.inputValueType = .milliliters
        state.outputValueType = .pints
        state.inputVolume = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultVolume, "0.002")
    }
    
    //MARK: - Cups
    func test_reduceCupsToPints() {
        state.inputValueType = .cups
        state.outputValueType = .pints
        state.inputVolume = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultVolume, "0.507")
    }
    
    func test_reduceCupsToGallons() {
        state.inputValueType = .cups
        state.outputValueType = .gallons
        state.inputVolume = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultVolume, "0.063")
    }
    
    func test_reduceCupsToLiters() {
        state.inputValueType = .cups
        state.outputValueType = .liters
        state.inputVolume = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultVolume, "0.24")
    }
    
    func test_reduceCupsToMilliliters() {
        state.inputValueType = .cups
        state.outputValueType = .milliliters
        state.inputVolume = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultVolume, "240")
    }
    
    //MARK: - Gallons
    func test_reduceGallonsToMilliliters() {
        state.inputValueType = .gallons
        state.outputValueType = .milliliters
        state.inputVolume = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultVolume, "3,785.41")
    }
    
    func test_reduceGallonsToLiters() {
        state.inputValueType = .gallons
        state.outputValueType = .liters
        state.inputVolume = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultVolume, "3.785")
    }
    
    func test_reduceGallonsToCups() {
        state.inputValueType = .gallons
        state.outputValueType = .cups
        state.inputVolume = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultVolume, "15.773")
    }
    
    func test_reduceGallonsToPints() {
        state.inputValueType = .gallons
        state.outputValueType = .pints
        state.inputVolume = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultVolume, "8")
    }
    
    //MARK: - Liters
    func test_reduceLitersToMilliliters() {
        state.inputValueType = .liters
        state.outputValueType = .milliliters
        state.inputVolume = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultVolume, "1,000")
    }
    
    func test_reduceLitersToPints() {
        state.inputValueType = .liters
        state.outputValueType = .pints
        state.inputVolume = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultVolume, "2.113")
    }
    
    func test_reduceLitersToGallons() {
        state.inputValueType = .liters
        state.outputValueType = .gallons
        state.inputVolume = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultVolume, "0.264")
    }
    
    func test_reduceLitersToCups() {
        state.inputValueType = .liters
        state.outputValueType = .cups
        state.inputVolume = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultVolume, "4.167")
    }
    
    //MARK: - Pints
    func test_reducePintsToCups() {
        state.inputValueType = .pints
        state.outputValueType = .cups
        state.inputVolume = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultVolume, "1.972")
    }
    
    func test_reducePintsToGallons() {
        state.inputValueType = .pints
        state.outputValueType = .gallons
        state.inputVolume = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultVolume, "0.125")
    }
    
    func test_reducePintsToMilliliters() {
        state.inputValueType = .pints
        state.outputValueType = .milliliters
        state.inputVolume = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultVolume, "473.176")
    }
    
    func test_reducePintsToLiters() {
        state.inputValueType = .pints
        state.outputValueType = .liters
        state.inputVolume = 1
        
        _ = sut.reduce(&state, action: .computeValue)
        
        XCTAssertEqual(state.resultVolume, "0.473")
    }
}
