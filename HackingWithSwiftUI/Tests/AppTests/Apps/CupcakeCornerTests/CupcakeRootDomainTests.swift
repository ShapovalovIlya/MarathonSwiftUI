//
//  RootDomainTests.swift
//  
//
//  Created by Илья Шаповалов on 22.08.2023.
//

import XCTest
import SwiftUDF
import CupcakeCorner

final class CupcakeRootDomainTests: XCTestCase {
    private var sut: RootDomain!
    private var state: RootDomain.State!
   
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
    
    func test_viewAppeared() {
        _ = sut.reduce(&state, action: .viewAppeared)
        
        XCTAssertEqual(state.userScenario, .order)
    }
    
    func test_reduceDeliveryButtonTap() {
        let testOrder: OrderDomain.Order = .init(
            type: .chocolate,
            quantity: 5,
            specialRequestEnabled: true,
            extraFrosting: true,
            addSprinkles: true
        )
        
        _ = sut.reduce(&state, action: .deliveryButtonTap(testOrder))
        
        XCTAssertEqual(state.userScenario, .address)
        XCTAssertEqual(state.order, testOrder)
    }
    
    func test_reduceCheckoutButtonTap() {
        let testAddress: AddressDomain.State = .init(
            name: "Baz",
            streetAddress: "Bar",
            city: "Foo",
            zip: "Bizz"
        )
        
        _ = sut.reduce(&state, action: .checkoutButtonTap(testAddress))
        
        XCTAssertEqual(state.userScenario, .checkout)
        XCTAssertEqual(state.address, testAddress)
    }
    
    func test_reduceBackButtonTapOnOrderScenario() {
        state.userScenario = .order
        
        _ = sut.reduce(&state, action: .backButtonTap)
        
        XCTAssertEqual(state.userScenario, .order)
    }
    
    func test_reduceBackButtonTapOnAddressScenario() {
        state.userScenario = .address
        
        _ = sut.reduce(&state, action: .backButtonTap)
        
        XCTAssertEqual(state.userScenario, .order)
    }

    func test_reduceBackButtonTapOnCheckoutScenario() {
        state.userScenario = .checkout
        
        _ = sut.reduce(&state, action: .backButtonTap)
        
        XCTAssertEqual(state.userScenario, .address)
    }
}
