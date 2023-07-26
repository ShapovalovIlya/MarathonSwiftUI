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
    
    func test_addNewWordToUsedWords() {
        state.rootWord = "baz"
        state.newWord = " Baz "
        state.usedWords = ["bar"]
        
        _ = sut.reduce(&state, action: .addNewWord)
        
        XCTAssertEqual(state.usedWords.first, "baz")
        XCTAssertTrue(state.newWord.isEmpty)
    }
    
    func test_addNewInappropriateWord() {
        state.newWord = "  "
        state.usedWords = ["bar"]
        
        _ = sut.reduce(&state, action: .addNewWord)
        
        XCTAssertEqual(state.usedWords.first, "bar")
        XCTAssertEqual(state.newWord, "  ")
    }
    
    func test_addNewWordDoesNotOrigin() {
        state.newWord = "Baz"
        state.usedWords = ["baz"]
        
        _ = sut.reduce(&state, action: .addNewWord)
        
        XCTAssertEqual(state.usedWords, ["baz"])
    }
    
    func test_addNewWordIsOrigin() {
        state.rootWord = "bar"
        state.newWord = "Bar"
        state.usedWords = ["baz"]
        
        _ = sut.reduce(&state, action: .addNewWord)
        
        XCTAssertEqual(state.usedWords, ["bar","baz"])
    }
    
    func test_addNewWordIsPossible() {
        state.rootWord = "baz"
        state.newWord = "ba"
        
        _ = sut.reduce(&state, action: .addNewWord)
        
        XCTAssertEqual(state.usedWords, ["ba"])
    }
    
    func test_addNewWordIsNotPossible() {
        state.rootWord = "baz"
        state.newWord = "foo"
        
        _ = sut.reduce(&state, action: .addNewWord)
        
        XCTAssertTrue(state.usedWords.isEmpty)
    }
    
    func test_addNewWordIsNotReal() {
        sut = .init(isReal: { _ in false })
        state.rootWord = "baz"
        state.newWord = "baz"
        
        _ = sut.reduce(&state, action: .addNewWord)
        
        XCTAssertTrue(state.usedWords.isEmpty)
    }
    
    func test_addNewWordIsReal() {
        sut = .init(isReal: { _ in true })
        state.rootWord = "baz"
        state.newWord = "baz"
        
        _ = sut.reduce(&state, action: .addNewWord)
        
        XCTAssertEqual(state.usedWords, ["baz"])
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

}
