//
//  RockPaperScissorsDomainTests.swift
//  
//
//  Created by Илья Шаповалов on 21.07.2023.
//

import XCTest
import RockPaperScissors
import Combine

final class RockPaperScissorsDomainTests: XCTestCase {
    private var sut: RockPaperScissorsDomain!
    private var state: RockPaperScissorsDomain.State!
    private var expectation: XCTestExpectation!

    override func setUp() async throws {
        try await super.setUp()
        
        sut = .init()
        state = .init()
        expectation = .init(description: "RockPaperScissorsDomainTests")
    }
    
    override func tearDown() async throws {
        sut = nil
        state = nil
        expectation = nil
        
        try await super.tearDown()
    }
    
    func test_setupRound_playerShouldWinState() {
        state.currentRound = 0
        sut = .init(
            weaponGenerator: { .paper },
            expectationGenerator: { .playerWin }
        )
        
        _ = sut.reduce(&state, action: .setupRound)
        
        XCTAssertEqual(state.gameExpectation, .playerWin)
        XCTAssertEqual(state.enemyWeapon, .paper)
        XCTAssertEqual(state.currentRound, 1)
    }
    
    func test_playerChooseWeapon() {
        _ = sut.reduce(&state, action: .playerChooseWeapon(.scissors))
        
        XCTAssertEqual(state.playerWeapon, .scissors)
    }
    
    func test_chooseWeaponEmitPlayRoundAction() {
        _ = sut.reduce(&state, action: .playerChooseWeapon(.paper))
            .sink(receiveValue: { [unowned self] action in
                expectation.fulfill()
                XCTAssertEqual(action, .playRound)
            })
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_gameResult_playerWin_MatchExpectation() {
        state.gameExpectation = .playerWin
        
        _ = sut.reduce(&state, action: .playerWin)
            .sink(receiveValue: { [unowned self] action in
                expectation.fulfill()
                XCTAssertEqual(action, .expectationFulfill)
            })
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_gameResult_playerWin_DontMatchExpectation() {
        state.gameExpectation = .draw
        
        _ = sut.reduce(&state, action: .playerWin)
            .sink(receiveValue: { [unowned self] action in
                expectation.fulfill()
                XCTAssertEqual(action, .expectationNotMatch)
            })
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_gameResult_playerLoose_DontMatchExpectation() {
        state.gameExpectation = .draw
        
        _ = sut.reduce(&state, action: .playerLose)
            .sink(receiveValue: { [unowned self] action in
                expectation.fulfill()
                XCTAssertEqual(action, .expectationNotMatch)
            })
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_gameResult_playerLoose_MatchExpectation() {
        state.gameExpectation = .playerLoose
        
        _ = sut.reduce(&state, action: .playerLose)
            .sink(receiveValue: { [unowned self] action in
                expectation.fulfill()
                XCTAssertEqual(action, .expectationFulfill)
            })
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_gameResult_draw_DontMatchExpectation() {
        state.gameExpectation = .playerWin
        
        _ = sut.reduce(&state, action: .draw)
            .sink(receiveValue: { [unowned self] action in
                expectation.fulfill()
                XCTAssertEqual(action, .expectationNotMatch)
            })
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_gameResult_draw_MatchExpectation() {
        state.gameExpectation = .draw
        
        _ = sut.reduce(&state, action: .draw)
            .sink(receiveValue: { [unowned self] action in
                expectation.fulfill()
                XCTAssertEqual(action, .expectationFulfill)
            })
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_gameResultMatchExpectation() {
        state.gameExpectation = .draw
        
        _ = sut.reduce(&state, action: .draw)
            .sink(receiveValue: { [unowned self] action in
                expectation.fulfill()
                XCTAssertEqual(action, .expectationFulfill)
            })
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_gameResultDontMatchExpectation() {
        state.gameExpectation = .playerWin
        
        _ = sut.reduce(&state, action: .draw)
            .sink(receiveValue: { [unowned self] action in
                expectation.fulfill()
                XCTAssertEqual(action, .expectationNotMatch)
            })
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_ExpectationFulfillEmitGameResultTrue() {
        _ = sut.reduce(&state, action: .expectationFulfill)
            .sink(receiveValue: { [unowned self] action in
                expectation.fulfill()
                XCTAssertEqual(action, .showGameResult(true))
            })
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_ExpectationNotMatchEmitGameResultFalse() {
        _ = sut.reduce(&state, action: .expectationNotMatch)
            .sink(receiveValue: { [unowned self] action in
                expectation.fulfill()
                XCTAssertEqual(action, .showGameResult(false))
            })
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_showGameResultSetupWin() {
        state.score = 0
        state.alertTitle = .init()
        state.alertDescription = .init()
        state.isAlertShown = false
        
        _ = sut.reduce(&state, action: .showGameResult(true))
        
        XCTAssertEqual(state.score, 1)
        XCTAssertEqual(state.alertTitle, "Right!")
        XCTAssertEqual(state.alertDescription, "Your score: 1")
        XCTAssertTrue(state.isAlertShown)
    }
    
    func test_showGameResultSetupLoose() {
        state.score = 1
        state.alertTitle = .init()
        state.alertDescription = .init()
        state.isAlertShown = false
        
        _ = sut.reduce(&state, action: .showGameResult(false))
        
        XCTAssertEqual(state.score, 0)
        XCTAssertEqual(state.alertTitle, "Wrong!")
        XCTAssertEqual(state.alertDescription, "Your score: 0")
        XCTAssertTrue(state.isAlertShown)
    }
    
    func test_scoreNeverGetBelowZero() {
        state.score = 0
        
        _ = sut.reduce(&state, action: .expectationNotMatch)
        
        XCTAssertEqual(state.score, 0)
    }
    
    func test_() {
        
    }
}
