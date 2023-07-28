import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(MyMacroMacros)
import MyMacroMacros

let testMacros: [String: Macro.Type] = [
    "stringify": StringifyMacro.self,
    "URL": URLMacro.self,
]
#endif

final class MyMacroTests: XCTestCase {
    func testMacro() throws {
        #if canImport(MyMacroMacros)
        assertMacroExpansion(
            """
            #stringify(a + b)
            """,
            expandedSource: """
            (a + b, "a + b")
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testMacroWithStringLiteral() throws {
        #if canImport(MyMacroMacros)
        assertMacroExpansion(
            #"""
            #stringify("Hello, \(name)")
            """#,
            expandedSource: #"""
            ("Hello, \(name)", #""Hello, \(name)""#)
            """#,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func test_ValidURL() throws {
        #if canImport(MyMacroMacros)
        assertMacroExpansion(
            #"""
            #URL("https://www.apple.com")
            """#,
            expandedSource: #"""
            URL(string: "https://www.apple.com")!
            """#,
            macros: testMacros)
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func test_URLStringLiteralError() throws {
        #if canImport(MyMacroMacros)
        assertMacroExpansion(
            #"""
            #URL("https://www.apple.com/\(Int.random())")
            """#,
            expandedSource: #"""
            
            """#,
            diagnostics: [
                .init(
                    message: "#URL requires a static string literal",
                    line: 1,
                    column: 1)
            ],
            macros: testMacros)
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
