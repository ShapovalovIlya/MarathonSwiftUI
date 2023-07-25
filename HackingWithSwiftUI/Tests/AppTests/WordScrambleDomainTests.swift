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
        
        sut = .init()
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
    
    func test_startGameEmitLoadWordsRequest() {
        _ = sut.reduce(&state, action: .startGame)
            .sink(receiveValue: { [unowned self] action in
                expectation.fulfill()
                XCTAssertEqual(action, .loadWordsRequest)
            })
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_loadWordRequestActionEndWithSuccess() {
        sut = .init(loadWords: {
            Just(["Baz"])
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        })
    }
    
//    func test_reduceLoadWordsResponce() {
//        _ = sut.reduce(&state, action: .loadWordsResponse(["baz"]))
//        
//        XCTAssertEqual(state.rootWord, "baz")
//    }

}
