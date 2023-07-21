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
    
    func test_setPlayerWeapon() {
        _ = sut.reduce(&state, action: .setPlayerWeapon(.scissors))
        
        XCTAssertEqual(state.playerWeapon, .scissors)
    }
    
    func test_setPlayerWeaponEmitRandomizeEnemyWeaponAction() {
        _ = sut.reduce(&state, action: .setPlayerWeapon(.scissors))
            .sink { [unowned self] action in
                expectation.fulfill()
                XCTAssertEqual(action, .getRandomEnemyWeapon)
            }
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_getRandomWeaponSetEnemyWeapon() {
        sut = RockPaperScissorsDomain(randomWeapon: { .paper })
        
        _ = sut.reduce(&state, action: .getRandomEnemyWeapon)
            .sink { [unowned self] action in
                expectation.fulfill()
                XCTAssertEqual(action, .setEnemyWeapon(.paper))
            }
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_setEnemyWeapon() {
        _ = sut.reduce(&state, action: .setEnemyWeapon(.scissors))
        
        XCTAssertEqual(state.enemyWeapon, .scissors)
    }
    
    func test_playRoundEmitAction() {
        _ = sut.reduce(&state, action: .playRound)
            .sink { [unowned self] action in
                expectation.fulfill()
                XCTAssertEqual(action, .computeBattle)
            }
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_computeBattleEmitPlayerWinAction() {
        state.playerWeapon = .rock
        state.enemyWeapon = .scissors
        
        _ = sut.reduce(&state, action: .computeBattle)
            .sink { [unowned self] action in
                expectation.fulfill()
                XCTAssertEqual(action, .playerWin)
            }
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_computeBattleEmitPlayerLooseAction() {
        state.playerWeapon = .paper
        state.enemyWeapon = .scissors
        
        _ = sut.reduce(&state, action: .computeBattle)
            .sink { [unowned self] action in
                expectation.fulfill()
                XCTAssertEqual(action, .playerLose)
            }
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_computeBattleEmitDraw() {
        state.playerWeapon = .paper
        state.enemyWeapon = .paper
        
        _ = sut.reduce(&state, action: .computeBattle)
            .sink { [unowned self] action in
                expectation.fulfill()
                XCTAssertEqual(action, .draw)
            }
        
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
