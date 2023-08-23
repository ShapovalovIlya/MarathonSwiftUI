//
//  RootDomainTests.swift
//  
//
//  Created by Илья Шаповалов on 22.08.2023.
//

import XCTest
import SwiftUDF
import CupcakeCorner
import Combine

final class CupcakeRootDomainTests: XCTestCase {
    private var sut: RootDomain!
    private var state: RootDomain.State!
    private var spy: ReducerSpy<RootDomain.Action>!
    private var testOrder: OrderDomain.Order!
    private var testEncodedOrder: Data!
    private var testError: Error!
   
    override func setUp() async throws {
        try await super.setUp()
        
        testOrder = .init(
            type: .chocolate,
            quantity: 3,
            specialRequestEnabled: true,
            extraFrosting: true,
            addSprinkles: true
        )
        testEncodedOrder = try JSONEncoder().encode(testOrder)
        sut = .init(sendOrder: { order in
            Just(order)
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
        testError = nil
        
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
    
    func test_placeOrderButtonTapEmitSendOrderRequest() {
        spy.schedule(
            sut.reduce(&state, action: .placeOrderButtonTap)
        )
        
        XCTAssertEqual(spy.actions.first, .sendOrderRequest)
    }
    
    func test_placeOrderRequestEndWithSuccess() {
        state.order = testOrder
        
        spy.schedule(
            sut.reduce(&state, action: .sendOrderRequest)
        )
        
        XCTAssertEqual(spy.actions.first, .sendOrderResponse(.success(testOrder)))
    }
    
    func test_placeOrderRequestEndWithError() {
        sut = .init(sendOrder: { [unowned self] _ in
            Fail(error: testError)
                .eraseToAnyPublisher()
        })
        
        spy.schedule(
            sut.reduce(&state, action: .sendOrderRequest)
        )
        
        XCTAssertEqual(spy.actions.first, .sendOrderResponse(.failure(testError)))
    }
    
    func test_reduceSuccessOrderResponce() {
        _ = sut.reduce(&state, action: .sendOrderResponse(.success(testOrder)))
        
        XCTAssertEqual(
            state.confirmationMessage,
            "Your order for \(testOrder.quantity)x \(testOrder.type.rawValue) cupcakes is on its way!"
        )
        XCTAssertTrue(state.showConfirmation)
    }
    
    func test_dismissAlert() {
        state.showConfirmation
        
        _ = sut.reduce(&state, action: .dismissAlert)
        
        XCTAssertFalse(state.showConfirmation)
    }
}
