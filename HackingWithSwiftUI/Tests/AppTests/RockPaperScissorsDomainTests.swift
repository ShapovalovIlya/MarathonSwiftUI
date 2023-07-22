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
        sut = .init(
            weaponGenerator: { .paper },
            expectationGenerator: { .playerWin }
        )
        
        _ = sut.reduce(&state, action: .setupRound)
        
        XCTAssertEqual(state.gameExpectation, .playerWin)
        XCTAssertEqual(state.enemyWeapon, .paper)
    }
    
    func test_setupRound_playerShouldLooseState() {
        sut = .init(
            weaponGenerator: { .rock },
            expectationGenerator: { .playerLoose }
        )
        
        _ = sut.reduce(&state, action: .setupRound)
        
        XCTAssertEqual(state.gameExpectation, .playerLoose)
        XCTAssertEqual(state.enemyWeapon, .rock)
    }
    
    func test_setupRound_drawState() {
        sut = .init(
            weaponGenerator: { .scissors },
            expectationGenerator: { .draw }
        )
        
        _ = sut.reduce(&state, action: .setupRound)
        
        XCTAssertEqual(state.gameExpectation, .draw)
        XCTAssertEqual(state.enemyWeapon, .scissors)
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
    
    func test_reduceStateWithPlayerWinAction() {
        _ = sut.reduce(&state, action: .playerWin)
        
        XCTAssertEqual(state.score, 1)
        XCTAssertEqual(state.alertTitle, "You win!")
        XCTAssertTrue(state.isAlertShown)
    }
    
    func test_reduceStateWithPlayerLooseAction() {
        state.score = 1
        
        _ = sut.reduce(&state, action: .playerLose)
        
        XCTAssertEqual(state.score, 0)
        XCTAssertEqual(state.alertTitle, "You Lose!")
        XCTAssertTrue(state.isAlertShown)
    }
    
    func test_scoreNeverBelowZero() {
        state.score = 0
        
        _ = sut.reduce(&state, action: .playerLose)
        
        XCTAssertEqual(state.score, 0)
    }
    
    
}
