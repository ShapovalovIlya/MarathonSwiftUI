//
//  RootDomainTests.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 02.08.2023.
//

import XCTest
import Combine
import MultiplicationTables

final class RootDomainTests: XCTestCase {
    private var sut: RootDomain!
    private var state: RootDomain.State!
    private var exp: XCTestExpectation!
    
    override func setUp() async throws {
        try await super.setUp()
        
        sut = .init()
        state = .init()
        exp = .init(description: "RootDomainTests")
    }
    
    override func tearDown() async throws {
        sut = nil
        state = nil
        exp = nil
        
        try await super.tearDown()
    }
    
    func test_reduceCommittedSettings() {
        let settings = SettingsDomain.State(tableDifficult: 2, totalQuestions: 5)
        let expectation = GameDomain.State(
            lhs: settings.tableDifficult,
            maxQuestions: settings.totalQuestions
        )
        
        _ = sut.reduce(&state, action: .commitSettings(settings))
        
        XCTAssertEqual(state, .game(expectation))
    }
    
    func test_reduceCommitGameResult() {
        let gameResult = GameDomain.State(lhs: 1, maxQuestions: 1, score: 1)
        
        _ = sut.reduce(&state, action: .commitGameResult(gameResult))
        
        
    }

}
