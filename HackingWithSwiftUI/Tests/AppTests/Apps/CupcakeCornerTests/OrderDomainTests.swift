//
//  OrderDomainTests.swift
//  
//
//  Created by Илья Шаповалов on 22.08.2023.
//

import XCTest
import SwiftUDF
import CupcakeCorner

final class OrderDomainTests: XCTestCase {
    private var sut: OrderDomain!
    private var state: OrderDomain.State!
    
    override func setUp() async throws {
        try await super.setUp()
        
        sut = .init()
        state = .init()
    }
    
    override func tearDown() async throws {
        sut = nil
        state = nil
        
        try await super.tearDown()
    }
    
    func test_setCupcakeType() {
        state.type = .vanilla
        
        _ = sut.reduce(&state, action: .setCupcakeType(.chocolate))
        
        XCTAssertEqual(state.type, .chocolate)
    }

}
