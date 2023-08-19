//
//  HabitDomainTests.swift
//  
//
//  Created by Илья Шаповалов on 19.08.2023.
//

import XCTest
import HabitsTracker
import SwiftUDF

final class HabitDomainTests: XCTestCase {
    private var sut: HabitDomain!
    private var state: HabitDomain.State!
  
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
    
    func test_setTitle() {
        _ = sut.reduce(&state, action: .setTitle("Baz"))
        
        XCTAssertEqual(state.title, "Baz")
        
        _ = sut.reduce(&state, action: .setTitle(" Bar "))
        
        XCTAssertEqual(state.title, "Bar")
        
        _ = sut.reduce(&state, action: .setTitle("Foo123"))
        
        XCTAssertEqual(state.title, "Foo")
    }
    
    func test_setDescription() {
        _ = sut.reduce(&state, action: .setDescription("Baz"))
        
        XCTAssertEqual(state.description, "Baz")
        
        _ = sut.reduce(&state, action: .setDescription(" Bar "))
        
        XCTAssertEqual(state.description, "Bar")
        
        _ = sut.reduce(&state, action: .setDescription("Foo 123"))
        
        XCTAssertEqual(state.description, "Foo 123")
    }
    
    func test_incrementHabitCount() {
        state.count = 0
        
        _ = sut.reduce(&state, action: .incrementButtonTap)
        
        XCTAssertEqual(state.count, 1)
    }
}
