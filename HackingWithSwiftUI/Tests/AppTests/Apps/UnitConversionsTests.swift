import XCTest
import SwiftUDF
import Combine
import UnitConversions

final class UnitConversionsTests: XCTestCase {
    
    private var sut: UnitConversionsDomain!
    private var state: UnitConversionsDomain.State!
    
    override func setUp() async throws {
        try await super.setUp()
        
        self.sut = .init()
        self.state = .init()
    }
    
    override func tearDown() async throws {
        self.sut = nil
        self.state = nil
        
        try await super.tearDown()
    }
    
    func test_setUnitType() {
        XCTAssertEqual(state.type, .temperature)
        
        _ = sut.reduce(&state, action: .setUnitType(.length))
        
        XCTAssertEqual(state.type, .length)
    }
    
}
