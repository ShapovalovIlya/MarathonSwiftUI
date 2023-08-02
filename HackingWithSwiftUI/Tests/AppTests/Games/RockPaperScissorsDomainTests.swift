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
    
    func test_initialStateIsPlayingGame() {
        _ = sut.reduce(&state, action: .setupRound)
        
        XCTAssertTrue(state.isPlayingGame)
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
    
    func test_playRoundEndWithFailingExpectations() {
        state.gameExpectation = .draw
        state.playerWeapon = .paper
        state.enemyWeapon = .rock
        
        _ = sut.reduce(&state, action: .playRound)
            .sink(receiveValue: { [unowned self] action in
                expectation.fulfill()
                XCTAssertEqual(action, .expectationResult(false))
            })
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_playRoundEndWithExpectationsFulfill() {
        state.gameExpectation = .draw
        state.playerWeapon = .paper
        state.enemyWeapon = .paper
        
        _ = sut.reduce(&state, action: .playRound)
            .sink(receiveValue: { [unowned self] action in
                expectation.fulfill()
                XCTAssertEqual(action, .expectationResult(true))
            })
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_ExpectationFulfillEmitGameResultTrue() {
        _ = sut.reduce(&state, action: .expectationResult(true))
            .sink(receiveValue: { [unowned self] action in
                expectation.fulfill()
                XCTAssertEqual(action, .showGameResult(true))
            })
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_ExpectationFulfillEmitGameOver() {
        state.currentRound = 10
        
        _ = sut.reduce(&state, action: .expectationResult(true))
            .sink(receiveValue: { [unowned self] action in
                expectation.fulfill()
                XCTAssertEqual(action, .gameOver)
            })
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_ExpectationNotMatchEmitGameResultFalse() {
        _ = sut.reduce(&state, action: .expectationResult(false))
            .sink(receiveValue: { [unowned self] action in
                expectation.fulfill()
                XCTAssertEqual(action, .showGameResult(false))
            })
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_ExpectationNotMatchEmitGameOver() {
        state.currentRound = 10
        
        _ = sut.reduce(&state, action: .expectationResult(false))
            .sink(receiveValue: { [unowned self] action in
                expectation.fulfill()
                XCTAssertEqual(action, .gameOver)
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
        
        _ = sut.reduce(&state, action: .expectationResult(false))
        
        XCTAssertEqual(state.score, 0)
    }
    
    func test_reduceGameOver() {
        state.score = 1
        state.isPlayingGame = true
        
        _ = sut.reduce(&state, action: .gameOver)
        
        XCTAssertEqual(state.alertDescription, "Your score is 1 from 10")
        XCTAssertFalse(state.isAlertShown)
        XCTAssertEqual(state.score, 0)
        XCTAssertEqual(state.currentRound, 0)
        XCTAssertFalse(state.isPlayingGame)
    }
    
    func test_reduceDismissAlert() {
        state.isAlertShown = true
        
        _ = sut.reduce(&state, action: .dismissAlert)
        
        XCTAssertFalse(state.isAlertShown)
    }
    
}
