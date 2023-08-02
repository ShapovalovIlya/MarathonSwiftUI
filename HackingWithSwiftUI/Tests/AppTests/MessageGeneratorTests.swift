//
//  MessageGeneratorTests.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 03.08.2023.
//

import XCTest
import AppDependencies

final class MessageGeneratorTests: XCTestCase {
    func test_unbelievableResult() {
        let result = MessageGenerator.compileMessage(4, 4)
        
        XCTAssertEqual(result, "You unbelievable!")
    }
    
    func test_veryGoodResult() {
        let result = MessageGenerator.compileMessage(3, 4)
        
        XCTAssertEqual(result, "You are very good!")
    }
    
    func test_mediumResult() {
        let result = MessageGenerator.compileMessage(2, 4)
        
        XCTAssertEqual(result, "You can handle math.")
    }
    
    func test_lowResult() {
        let result = MessageGenerator.compileMessage(1, 4)
        
        XCTAssertEqual(result, "Keep practice")
    }
}
