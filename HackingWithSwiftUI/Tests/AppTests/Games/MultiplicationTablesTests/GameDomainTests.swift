//
//  GameDomainTests.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 01.08.2023.
//

import XCTest
import MultiplicationTables

final class GameDomainTests: XCTestCase {
    private var sut: GameDomain!
    private var state: GameDomain.State!
    private var exp: XCTestExpectation!
   
    override func setUp() async throws {
        try await super.setUp()
        
        sut = .init()
        state = .init(lhs: 2, maxQuestions: 20)
        exp = .init(description: "GameDomainTests")
    }
    
    override func tearDown() async throws {
        sut = nil
        state = nil
        exp = nil
        
        try await super.tearDown()
    }
    
    func test_askQuestion() {
        state.guess = 1
        sut = .init(randomInt: { 2 })
        
        _ = sut.reduce(&state, action: .askQuestion)
        
        XCTAssertEqual(state.lhs, 2)
        XCTAssertEqual(state.rhs, 2)
        XCTAssertEqual(state.currentQuestion, 1)
        XCTAssertEqual(state.guess, 0)
    }
    
    func test_reduceSetGuessAction() {
        _ = sut.reduce(&state, action: .setGuess(2))
        
        XCTAssertEqual(state.guess, 2)
    }
    
    func test_reduceResolveButtonTapEmitGuessIsCorrectTrue() {
        state.lhs = 2
        state.rhs = 2
        state.guess = 4
        
        _ = sut.reduce(&state, action: .resolveButtonTap)
            .sink(receiveValue: { [unowned self] action in
                exp.fulfill()
                XCTAssertEqual(action, .guessIsCorrect(true))
            })
        
        wait(for: [exp], timeout: 0.1)
    }
    
    func test_reduceResolveButtonTapEmitGuessIsCorrectFalse() {
        state.lhs = 2
        state.rhs = 2
        state.guess = 3
        
        _ = sut.reduce(&state, action: .resolveButtonTap)
            .sink(receiveValue: { [unowned self] action in
                exp.fulfill()
                XCTAssertEqual(action, .guessIsCorrect(false))
            })
        
        wait(for: [exp], timeout: 0.1)
    }
    
    func test_reduceGuessIsCorrectTrueAction() {
        state.score = 0
        state.isAlertShown = false
        state.alertTitle = .init()
        
        _ = sut.reduce(&state, action: .guessIsCorrect(true))
        
        XCTAssertEqual(state.score, 1)
        XCTAssertTrue(state.isAlertShown)
        XCTAssertEqual(state.alertTitle, "You right!")
    }
    
    func test_reduceGuessIsCorrectFalseAction() {
        state.score = 0
        state.isAlertShown = false
        state.alertTitle = .init()
        
        _ = sut.reduce(&state, action: .guessIsCorrect(false))
        
        XCTAssertEqual(state.score, 0)
        XCTAssertTrue(state.isAlertShown)
        XCTAssertEqual(state.alertTitle, "Wrong answer")
    }
    
    func test_continueButtonTapEmitAskQuestionAction() {
        state.maxQuestions = 2
        state.currentQuestion = 1
        
        _ = sut.reduce(&state, action: .continueButtonTap)
            .sink(receiveValue: { [unowned self] action in
                exp.fulfill()
                XCTAssertEqual(action, .askQuestion)
            })
        
        wait(for: [exp], timeout: 0.1)
    }
    
    func test_continueButtonTapEmitGameOverAction() {
        state.maxQuestions = 2
        state.currentQuestion = 2
        
        _ = sut.reduce(&state, action: .continueButtonTap)
            .sink(receiveValue: { [unowned self] action in
                exp.fulfill()
                XCTAssertEqual(action, .gameOver)
            })
        
        wait(for: [exp], timeout: 0.1)
    }
    
    func test_reduceGameOverAction() {
        state.isGameOver = false
        state.alertTitle = .init()
        
        _ = sut.reduce(&state, action: .gameOver)
        
        XCTAssertTrue(state.isGameOver)
        XCTAssertEqual(state.alertTitle, "Game over!")
    }
    
    func test_reduceDismissAlertAction() {
        state.isAlertShown = true
        
        _ = sut.reduce(&state, action: .dismissAlert)
        
        XCTAssertFalse(state.isAlertShown)
    }

}
