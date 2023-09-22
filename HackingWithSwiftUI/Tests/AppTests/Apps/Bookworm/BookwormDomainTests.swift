//
//  BookwormDomainTests.swift
//  
//
//  Created by Илья Шаповалов on 22.09.2023.
//

import XCTest
import Bookworm
import Combine
import SwiftUDF

final class BookwormDomainTests: XCTestCase {
    private var sut: BookwormDomain!
    private var state: BookwormDomain.State!
    private var spy: ReducerSpy<BookwormDomain.Action>!
    
    override func setUp() async throws {
        try await super.setUp()
        
        
    }
    
    override func tearDown() async throws {
        
        
        try await super.tearDown()
    }
    
    func test_fetchStudents() {
        
    }

}
