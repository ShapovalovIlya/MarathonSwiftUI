//
//  WordScrambleDomainTests.swift
//  
//
//  Created by Илья Шаповалов on 25.07.2023.
//

import XCTest
import WordScramble
import Combine

final class WordScrambleDomainTests: XCTestCase {
    private var sut: WordScrambleDomain!
    private var state: WordScrambleDomain.State!
    private var expectation: XCTestExpectation!
    
    override func setUp() async throws {
        try await super.setUp()
        
        sut = .init(isReal: { _ in true })
        state = .init()
        expectation = .init(description: "WordScrambleDomainTests")
    }
    
    override func tearDown() async throws {
        sut = nil
        state = nil
        expectation = nil
        
        try await super.tearDown()
    }
    
    func test_setNewWord() {
        _ = sut.reduce(&state, action: .setNewWord("Baz"))
        
        XCTAssertEqual(state.newWord, "Baz")
    }
    
    func test_addNewWordEndWithSuccess() {
        state.rootWord = "bazilisk"
        state.newWord = " Baz "
        state.usedWords = ["bar"]
        
        _ = sut.reduce(&state, action: .addNewWord)
            .sink(receiveValue: { [unowned self] action in
                expectation.fulfill()
                XCTAssertEqual(action, .addNewWordResult(.success("baz")))
            })
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_addNewWordEmitInappropriateError() {
        state.newWord = "  "
        state.usedWords = ["bar"]
        
        _ = sut.reduce(&state, action: .addNewWord)
            .sink(receiveValue: { [unowned self] action in
                expectation.fulfill()
                XCTAssertEqual(action, .addNewWordResult(.failure(.inappropriate)))
            })
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_addNewWordEmitErrorNotOriginal() {
        state.newWord = "Baz"
        state.usedWords = ["baz"]
        
        _ = sut.reduce(&state, action: .addNewWord)
            .sink(receiveValue: { [unowned self] action in
                expectation.fulfill()
                XCTAssertEqual(action, .addNewWordResult(.failure(.notOriginal)))
            })
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_addNewWordEmitErrorNotPossible() {
        state.rootWord = "baz"
        state.newWord = "foo"
        
        _ = sut.reduce(&state, action: .addNewWord)
            .sink(receiveValue: { [unowned self] action in
                expectation.fulfill()
                XCTAssertEqual(action, .addNewWordResult(.failure(.notPossible)))
            })
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_addNewWordEmitErrorNotReal() {
        sut = .init(isReal: { _ in false })
        state.rootWord = "bazilisk"
        state.newWord = "baz"
        
        _ = sut.reduce(&state, action: .addNewWord)
            .sink(receiveValue: { [unowned self] action in
                expectation.fulfill()
                XCTAssertEqual(action, .addNewWordResult(.failure(.notReal)))
            })
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_addNewWordEmitErrorEqualsToRootWord() {
        state.rootWord = "baz"
        state.newWord = "baz"
        
        _ = sut.reduce(&state, action: .addNewWord)
            .sink(receiveValue: { [unowned self] action in
                expectation.fulfill()
                XCTAssertEqual(action, .addNewWordResult(.failure(.equalsToRootWord)))
            })
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_reduceAddNewWordSuccessResult() {
        state.newWord = "baz"
        state.usedWords = []
        
        _ = sut.reduce(&state, action: .addNewWordResult(.success("baz")))
        
        XCTAssertTrue(state.newWord.isEmpty)
        XCTAssertTrue(state.usedWords.contains("baz"))
        XCTAssertFalse(state.showError)
    }
    
    func test_reduceAddNewWordFailureResultInappropriate() {
        _ = sut.reduce(&state, action: .addNewWordResult(.failure(.inappropriate)))
        
        XCTAssertEqual(
            state.errorTitle,
            WordScrambleDomain.WordError.inappropriate.title
        )
        XCTAssertEqual(
            state.errorMessage,
            WordScrambleDomain.WordError.inappropriate.message
        )
        XCTAssertTrue(state.showError)
    }
    
    func test_reduceAddNewWordFailureResultNotOriginal() {
        _ = sut.reduce(&state, action: .addNewWordResult(.failure(.notOriginal)))
        
        XCTAssertEqual(
            state.errorTitle,
            WordScrambleDomain.WordError.notOriginal.title
        )
        XCTAssertEqual(
            state.errorMessage,
            WordScrambleDomain.WordError.notOriginal.message
        )
        XCTAssertTrue(state.showError)
    }
    
    func test_reduceAddNewWordFailureResultNotPossible() {
        _ = sut.reduce(&state, action: .addNewWordResult(.failure(.notPossible)))
        
        XCTAssertEqual(
            state.errorTitle,
            WordScrambleDomain.WordError.notPossible.title
        )
        XCTAssertEqual(
            state.errorMessage,
            WordScrambleDomain.WordError.notPossible.message
        )
        XCTAssertTrue(state.showError)
    }
    
    func test_reduceAddNewWordFailureResultNotReal() {
        _ = sut.reduce(&state, action: .addNewWordResult(.failure(.notReal)))
        
        XCTAssertEqual(
            state.errorTitle,
            WordScrambleDomain.WordError.notReal.title
        )
        XCTAssertEqual(
            state.errorMessage,
            WordScrambleDomain.WordError.notReal.message
        )
        XCTAssertTrue(state.showError)
    }
    
    func test_reduceDismissAlertAction() {
        state.showError = true
        
        _ = sut.reduce(&state, action: .dismissAlert)
        
        XCTAssertFalse(state.showError)
    }
    
    func test_startGameEmitLoadWordsRequest() {
        _ = sut.reduce(&state, action: .startGame)
            .sink(receiveValue: { [unowned self] action in
                expectation.fulfill()
                XCTAssertEqual(action, .loadWordsRequest)
            })
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_loadWordRequestActionEndWithSuccess() {
        let testArr = ["Baz"]
        sut = .init(loadWords: {
            Just(testArr)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        })
        
        _ = sut.reduce(&state, action: .loadWordsRequest)
            .sink(receiveValue: { [unowned self] action in
                expectation.fulfill()
                XCTAssertEqual(action, .loadWordsResponse(.success(testArr)))
            })
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_loadWordRequestActionEndWithError() {
        let testErr: Error = CocoaError(.fileNoSuchFile)
        sut = .init(loadWords: {
            Fail(error: testErr)
                .eraseToAnyPublisher()
        })
        
        _ = sut.reduce(&state, action: .loadWordsRequest)
            .sink(receiveValue: { [unowned self] action in
                expectation.fulfill()
                XCTAssertEqual(action, .loadWordsResponse(.failure(testErr)))
            })
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_reduceSuccessLoadWordRequest() {
        _ = sut.reduce(&state, action: .loadWordsResponse(.success(["Baz"])))
        
        XCTAssertEqual(state.rootWord, "Baz")
    }
    
    func test_reduceFailureLoadWordRequest() {
        _ = sut.reduce(&state, action: .loadWordsResponse(.failure(URLError(.badURL))))
        
        XCTAssertTrue(state.rootWord.isEmpty)
    }
    
    func test_increaseUserScore() {
        let testWord = "Baz"
        state.userScore = 0
        
        _ = sut.reduce(&state, action: .addNewWordResult(.success(testWord)))
        
        XCTAssertEqual(state.userScore, testWord.count)
    }

}
