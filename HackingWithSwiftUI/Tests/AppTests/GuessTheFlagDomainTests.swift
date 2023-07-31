//
//  GuessTheFlagDomainTests.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 31.07.2023.
//

import XCTest
import GuessTheFlag
import Combine

final class GuessTheFlagDomainTests: XCTestCase {
    private var sut: GuessTheFlagDomain!
    private var state: GuessTheFlagDomain.State!
    private var testExp: XCTestExpectation!
   
    override func setUp() async throws {
        try await super.setUp()
        
        sut = .init()
        state = .init()
        testExp = .init(description: "GuessTheFlagDomainTests")
    }
    
    override func tearDown() async throws {
        sut = nil
        state = nil
        testExp = nil
        
        try await super.tearDown()
    }
    
    func test_reduceAskQuestionAction() {
        sut = .init(
            randomInt: { 1 },
            shuffler: { _ in ["Baz", "Bar"] }
        )
        _ = sut.reduce(&state, action: .askQuestion)
        
        XCTAssertEqual(state.countries, ["Baz", "Bar"])
        XCTAssertEqual(state.correctAnswer, 1)
        XCTAssertEqual(state.currentNumberOfQuestions, 1)
    }
    
    func test_tupOnFlagEmitRightAnswer() {
        sut = .init(scheduler: .current)
        state.correctAnswer = 0
        state.countries = ["Baz", "Bar"]
        
        _ = sut.reduce(&state, action: .tapOnFlag("Baz"))
            .subscribe(on: RunLoop.current)
            .sink(receiveValue: { [unowned self] action in
                testExp.fulfill()
                XCTAssertEqual(action, .rightAnswer)
            })
        
        wait(for: [testExp], timeout: 2)
    }
    
    func test_tupOnFlagEmitWrongAnswer() {
        sut = .init(scheduler: .current)
        
        _ = sut.reduce(&state, action: .tapOnFlag("Baz"))
            .subscribe(on: RunLoop.current)
            .sink(receiveValue: { [unowned self] action in
                testExp.fulfill()
                XCTAssertEqual(action, .wrongAnswer("Baz"))
            })
        
        wait(for: [testExp], timeout: 2)
    }
    
    func test_reduceStateWithWrongAnswer() {
        _ = sut.reduce(&state, action: .wrongAnswer("Baz"))
        
        XCTAssertEqual(state.scoreTitle, "Wrong! That the flag of: Baz")
        XCTAssertTrue(state.showScore)
    }
    
    func test_reduceStateWithRightAnswer() {
        state.score = 0
        
        _ = sut.reduce(&state, action: .rightAnswer)
        
        XCTAssertEqual(state.scoreTitle, "Right!")
        XCTAssertTrue(state.showScore)
        XCTAssertEqual(state.score, 1)
    }
    
    func test_reduceCloseAlertAction() {
        state.showScore = true
        state.showFinalScore = true
        
        _ = sut.reduce(&state, action: .closeAlert)
        
        XCTAssertFalse(state.showScore)
        XCTAssertFalse(state.showFinalScore)
    }
    
    func test_reduceShowFinalScoreAction() {
        state.score = 1
        state.showFinalScore = false
        
        _ = sut.reduce(&state, action: .showFinalScore)
        
        XCTAssertTrue(state.showFinalScore)
        XCTAssertEqual(state.scoreTitle, "Game over! Your final score is: 1")
    }
    
    func test_reduceRestartGame() {
        sut = .init(
            randomInt: { 1 },
            shuffler: { _ in ["Baz", "Bar"] }
        )
        state.score = 1
        state.currentNumberOfQuestions = 1
        
        _ = sut.reduce(&state, action: .restartGame)
        
        XCTAssertEqual(state.score, .zero)
        XCTAssertEqual(state.currentNumberOfQuestions, .zero)
        XCTAssertEqual(state.correctAnswer, 1)
        XCTAssertEqual(state.countries, ["Baz", "Bar"])
    }
    
    func test_askQuestionEmitShowFinalScoreAction() {
        state.currentNumberOfQuestions = 9
        
        _ = sut.reduce(&state, action: .askQuestion)
            .sink(receiveValue: { [unowned self] action in
                testExp.fulfill()
                XCTAssertEqual(action, .showFinalScore)
            })
        
        wait(for: [testExp], timeout: 0.1)
    }
}
