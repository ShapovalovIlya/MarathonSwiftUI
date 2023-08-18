//
//  HabitListDomainTests.swift
//  
//
//  Created by Илья Шаповалов on 18.08.2023.
//

import XCTest
import HabitsTracker
import SwiftUDF
import Combine

final class HabitListDomainTests: XCTestCase {
    private var sut: HabitListDomain!
    private var state: HabitListDomain.State!
    private var spy: ReducerSpy<HabitListDomain.Action>!
    private var testModels: [Habit]!
    private var testError: Error!
    
    override func setUp() async throws {
        try await super.setUp()
        
        testModels = [
            .init(),
            .init()
        ]
        sut = .init(loadHabits: { [unowned self] _ in
            Just(testModels)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        })
        state = .init()
        spy = .init()
        testError = URLError(.badURL)
    }
    
    override func tearDown() async throws {
        sut = nil
        state = nil
        spy = nil
        testModels = nil
        testError = nil
        
        try await super.tearDown()
    }
    
    func test_viewAppearedActionEmitLoadHabitsRequestAction() {
        spy.schedule(
            sut.reduce(&state, action: .viewAppeared)
        )
        
        XCTAssertEqual(spy.actions.first, .loadHabitsRequest)
    }

    func test_loadHabitsRequestEndWithError() {
        sut = .init(loadHabits: { [unowned self] _ in
            Fail(error: testError)
                .eraseToAnyPublisher()
        })
        
        spy.schedule(
            sut.reduce(&state, action: .loadHabitsRequest)
        )
        
        XCTAssertEqual(spy.actions.first, .loadHabitsResponse(.failure(testError)))
    }
    
    func test_loadHabitsRequestEndWithSuccess() {
        spy.schedule(
            sut.reduce(&state, action: .loadHabitsRequest)
        )
        
        XCTAssertEqual(spy.actions.first, .loadHabitsResponse(.success(testModels)))
    }
}
