//
//  OrderDomainTests.swift
//  
//
//  Created by Илья Шаповалов on 22.08.2023.
//

import XCTest
import SwiftUDF
import CupcakeCorner

final class OrderDomainTests: XCTestCase {
    private var sut: OrderDomain!
    private var state: OrderDomain.State!
    
    override func setUp() async throws {
        try await super.setUp()
        
        sut = .init()
        state = .init()
    }
    
    override func tearDown() async throws {
        sut = nil
        state = nil
        
        try await super.tearDown()
    }
    
    func test_setCupcakeType() {
        state.type = .vanilla
        
        _ = sut.reduce(&state, action: .setCupcakeType(.chocolate))
        
        XCTAssertEqual(state.type, .chocolate)
    }
    
    func test_setQuantity() {
        _ = sut.reduce(&state, action: .setQuantity(1))
        
        XCTAssertEqual(state.quantity, 1)
    }
    
    func test_toggleSpecialRequest() {
        state.specialRequestEnabled = false
        
        _ = sut.reduce(&state, action: .toggleSpecialRequest(true))
        
        XCTAssertTrue(state.specialRequestEnabled)
        
        _ = sut.reduce(&state, action: .toggleSpecialRequest(false))
        
        XCTAssertFalse(state.specialRequestEnabled)
    }
    
    func test_toggleExtraFrosting() {
        state.extraFrosting = false
        
        _ = sut.reduce(&state, action: .toggleExtraFrosting(true))
        
        XCTAssertTrue(state.extraFrosting)
        
        _ = sut.reduce(&state, action: .toggleExtraFrosting(false))
        
        XCTAssertFalse(state.extraFrosting)
    }
    
    func test_toggleAddSprinkles() {
        state.addSprinkles = false
        
        _ = sut.reduce(&state, action: .toggleAddSprinkles(true))
        
        XCTAssertTrue(state.addSprinkles)
        
        _ = sut.reduce(&state, action: .toggleAddSprinkles(false))
        
        XCTAssertFalse(state.addSprinkles)
    }
    
    func test_toggleSpecialRequestToFalseToggleExtraFrosting() {
        state.specialRequestEnabled = true
        state.extraFrosting = true
        
        _ = sut.reduce(&state, action: .toggleSpecialRequest(false))
        
        XCTAssertFalse(state.specialRequestEnabled)
        XCTAssertFalse(state.extraFrosting)
    }
    
    func test_toggleSpecialRequestToFalseToggleSprinkles() {
        state.specialRequestEnabled = true
        state.addSprinkles = true
        
        _ = sut.reduce(&state, action: .toggleSpecialRequest(false))
        
        XCTAssertFalse(state.specialRequestEnabled)
        XCTAssertFalse(state.addSprinkles)
    }

}
