//
//  MultiplicationSettingsDomainTests.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 01.08.2023.
//

import XCTest
import MultiplicationTables

final class MultiplicationSettingsDomainTests: XCTestCase {
    private var sut: SettingsDomain!
    private var state: SettingsDomain.State!
    private var exp: XCTestExpectation!
    
    override func setUp() async throws {
        try await super.setUp()
        
        sut = .init()
        state = .init()
        exp = .init(description: "MultiplicationSettingsDomainTests")
    }
    
    override func tearDown() async throws {
        sut = nil
        state = nil
        exp = nil
        
        try await super.tearDown()
    }
    
    func test_setTableDifficult() {
        _ = sut.reduce(&state, action: .setDifficult(3))
        
        XCTAssertEqual(state.tableDifficult, 3)
    }
    
    func test_setNumberOfQuestions() {
        _ = sut.reduce(&state, action: .setTotalQuestions(15))
        
        XCTAssertEqual(state.totalQuestions, 15)
    }

}
