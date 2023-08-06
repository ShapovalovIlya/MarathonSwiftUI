//
//  MoonshotDomainTests.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 06.08.2023.
//

import XCTest
import Moonshot
import Shared
import Combine

final class MoonshotDomainTests: XCTestCase {
    private var sut: MoonshotDomain!
    private var state: MoonshotDomain.State!
    private var exp: XCTestExpectation!
    private var testAstronauts: [String: Astronaut]!
    private var testMissions: [Mission]!
    private var testError: Error!
    
    override func setUp() async throws {
        try await super.setUp()
        
        sut = .init()
        state = .init()
        exp = .init(description: "MoonshotDomainTests")
        testAstronauts = [
            "Baz" : .init(id: "Baz", name: "Baz", description: "Baz"),
            "Bar" : .init(id: "Bar", name: "Bar", description: "Bar"),
            "Foo" : .init(id: "Foo", name: "Foo", description: "Foo")
        ]
        testMissions = [
            .init(id: 1, launchDate: "Baz", crew: [.init(name: "Baz", role: "Baz")], description: "Baz"),
            .init(id: 1, launchDate: "Bar", crew: [.init(name: "Bar", role: "Bar")], description: "Bar"),
            .init(id: 1, launchDate: "Foo", crew: [.init(name: "Foo", role: "Foo")], description: "Foo")
        ]
        testError = URLError(.badURL)
    }
    
    override func tearDown() async throws {
        sut = nil
        state = nil
        exp = nil
        testAstronauts = nil
        testMissions = nil
        testError = nil
    }
    
    func test_viewAppearEmitRequestActions() {
        sut = .init(
            getAstronauts: { [unowned self] _ in
                Fail(error: testError)
                    .eraseToAnyPublisher()
            },
            getMissions: { [unowned self] _ in
                Fail(error: testError)
                    .eraseToAnyPublisher()
            }
        )
        
        _ = sut.reduce(&state, action: .viewAppeared)
            .collect()
            .sink(receiveValue: {
                [unowned self] actions in
                exp.fulfill()
                XCTAssertEqual(actions, [.loadAstronauts, .loadMissions])
            })
        
        wait(for: [exp], timeout: 0.1)
    }
    
    func test_loadAstronautsEndWithSuccess() {
        sut = .init(getAstronauts: { [unowned self] _ in
            Just(testAstronauts)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        })
        
        _ = sut.reduce(&state, action: .loadAstronauts)
            .sink(receiveValue: { [unowned self] action in
                exp.fulfill()
                XCTAssertEqual(action, .loadAstronautsResponse(.success(testAstronauts)))
            })
        
        wait(for: [exp], timeout: 0.1)
    }
    
    func test_reduceSuccessLoadAstronautsResponse() {
        state.astronauts = .init()
        
        _ = sut.reduce(&state, action: .loadAstronautsResponse(.success(testAstronauts)))
        
        XCTAssertEqual(state.astronauts, testAstronauts)
    }
    
    func test_loadAstronautsEndWithError() {
        sut = .init(getAstronauts: { [unowned self] _ in
            Fail(error: testError)
                .eraseToAnyPublisher()
        })
        
        _ = sut.reduce(&state, action: .loadAstronauts)
            .sink(receiveValue: { [unowned self] action in
                exp.fulfill()
                XCTAssertEqual(action, .loadAstronautsResponse(.failure(testError)))
            })
        
        wait(for: [exp], timeout: 0.1)
    }
    
    func test_reduceFailureLoadAstronautsResponse() {
        state.astronauts = .init()
        
        _ = sut.reduce(&state, action: .loadAstronautsResponse(.failure(testError)))
        
        XCTAssertTrue(state.astronauts.isEmpty)
    }
    
    func test_loadMissionsEndWithSuccess() {
        sut = .init(getMissions: { [unowned self] _ in
            Just(testMissions)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        })
        
        _ = sut.reduce(&state, action: .loadMissions)
            .sink(receiveValue: { [unowned self] action in
                exp.fulfill()
                XCTAssertEqual(action, .loadMissionsResponse(.success(testMissions)))
            })
        
        wait(for: [exp], timeout: 0.1)
    }
    
    func test_reduceSuccessLoadMissionsResponse() {
        state.missions = .init()
        
        _ = sut.reduce(&state, action: .loadMissionsResponse(.success(testMissions)))
        
        XCTAssertEqual(state.missions, testMissions)
    }
    
    func test_loadMissionsEndWithError() {
        sut = .init(getMissions: { [unowned self] _ in
            Fail(error: testError)
                .eraseToAnyPublisher()
        })
        
        _ = sut.reduce(&state, action: .loadMissions)
            .sink(receiveValue: { [unowned self] action in
                exp.fulfill()
                XCTAssertEqual(action, .loadMissionsResponse(.failure(testError)))
            })
        
        wait(for: [exp], timeout: 0.1)
    }
    
    func test_reduceFailLoadMissionsResponse() {
        state.missions = .init()
        
        _ = sut.reduce(&state, action: .loadMissionsResponse(.failure(testError)))
        
        XCTAssertTrue(state.missions.isEmpty)
    }
    
}
