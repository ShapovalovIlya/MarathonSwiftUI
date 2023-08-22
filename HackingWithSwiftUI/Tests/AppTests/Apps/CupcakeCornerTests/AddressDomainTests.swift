//
//  AddressDomainTests.swift
//  
//
//  Created by Илья Шаповалов on 22.08.2023.
//

import XCTest
import SwiftUDF
import CupcakeCorner

final class AddressDomainTests: XCTestCase {
    private var sut: AddressDomain!
    private var state: AddressDomain.State!
    
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
    
    func test_setName() {
        _ = sut.reduce(&state, action: .setName("Baz"))
        
        XCTAssertEqual(state.name, "Baz")
    }
    
    func test_setStreetAddress() {
        _ = sut.reduce(&state, action: .setStreetAddress("Baz"))
        
        XCTAssertEqual(state.streetAddress, "Baz")
    }
    
    func test_setCity() {
        _ = sut.reduce(&state, action: .setCity("Baz"))
        
        XCTAssertEqual(state.city, "Baz")
    }
    
    func test_setZip() {
        _ = sut.reduce(&state, action: .setZip("Baz"))
        
        XCTAssertEqual(state.zip, "Baz")
    }
}
