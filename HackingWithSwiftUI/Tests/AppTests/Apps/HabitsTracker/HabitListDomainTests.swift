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
            .init(title: "Baz", description: "Baz", count: 1),
            .init(title: "Bar", description: "Bar", count: 2)
        ]
        sut = .init(
            loadHabits: { [unowned self] _ in
                Just(testModels)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            },
            saveHabits: { _,_  in }
        )
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
        
        XCTAssertEqual(spy.actions.first, .loadHabitsResponse([]))
    }
    
    func test_loadHabitsRequestEndWithSuccess() {
        spy.schedule(
            sut.reduce(&state, action: .loadHabitsRequest)
        )
        
        XCTAssertEqual(spy.actions.first, .loadHabitsResponse(testModels))
    }
    
    func test_reduceSuccessLoadHabitResponse() {
        _ = sut.reduce(&state, action: .loadHabitsResponse(testModels))
        
        XCTAssertEqual(state.habits, testModels)
    }
    
    func test_reduceFailLoadHabitResponse() {
        sut = .init(loadHabits: { [unowned self] _ in
            Fail(error: testError)
                .eraseToAnyPublisher()
        })
        
        _ = sut.reduce(&state, action: .loadHabitsResponse([]))
        
        XCTAssertTrue(state.habits.isEmpty)
    }
    
    func test_reduceRemoveHabitsAtOffset() {
        state.habits = testModels
        
        spy.schedule(
            sut.reduce(&state, action: .removeHabitAtOffset(.init(integer: 1)))
        )
        
        XCTAssertEqual(state.habits.count, testModels.count - 1)
        XCTAssertEqual(spy.actions.first, .saveHabitsRequest)
    }
    
    func test_reduceMoveHabitsToOffset() {
        state.habits = testModels
        
        spy.schedule(
            sut.reduce(&state, action: .moveHabit(from: .init(integer: 1), to: 0))
        )
        
        XCTAssertEqual(state.habits.first, testModels.last)
    }
    
    func test_reduceUpdateHabitAction() {
        state.habits = testModels
        var tempModel = testModels[0]
        tempModel.count = 10
        
        spy.schedule(
            sut.reduce(&state, action: .updateHabit(tempModel))
        )
        
        XCTAssertEqual(state.habits.count, 2)
        XCTAssertEqual(state.habits.first, tempModel)
        XCTAssertEqual(spy.actions.first, .saveHabitsRequest)
    }
    
    func test_saveHabitRequestEndWithSuccess() {
        spy.schedule(
            sut.reduce(&state, action: .saveHabitsRequest)
        )
        
        XCTAssertTrue(spy.actions.isEmpty)
    }
    
    func test_saveHabitRequestEndWithError() {
        sut = .init(saveHabits: { _,_  in throw URLError(.badURL) })
        
        spy.schedule(
            sut.reduce(&state, action: .saveHabitsRequest)
        )
        
        XCTAssertTrue(state.isAlert)
    }
    
    func test_dismissAlert() {
        state.isAlert = true
        
        _ = sut.reduce(&state, action: .dismissAlert)
        
        XCTAssertFalse(state.isAlert)
    }
    
    func test_reduceAddHabitButtonTap() {
        _ = sut.reduce(&state, action: .addHabitButtonTap)
        
        XCTAssertTrue(state.isShowSheet)
    }
    
    func test_dismissSheet() {
        state.isShowSheet = true
        
        _ = sut.reduce(&state, action: .dismissSheet)
        
        XCTAssertFalse(state.isShowSheet)
    }
    
}
