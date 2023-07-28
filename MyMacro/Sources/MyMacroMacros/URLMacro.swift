//
//  URLMacro.swift
//  
//
//  Created by Илья Шаповалов on 28.07.2023.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

enum URLMacroError: Error, CustomDebugStringConvertible {
    case requiresStaticStringLiteral
    case malformedURL(String)
    
    var debugDescription: String {
        switch self {
        case .requiresStaticStringLiteral:
            return "#URL requires a static string literal"
        case let .malformedURL(urlString):
            return "The input URL is malformed: \(urlString)"
        }
    }
}

public struct URLMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        guard
            let argument = node.argumentList.first?.expression,
            let segments = argument.as(StringLiteralExprSyntax.self)?.segments,
            segments.count == 1,
            case let .stringSegment(literalSegment)? = segments.first
        else {
            throw URLMacroError.requiresStaticStringLiteral
        }
        guard let _ = URL(string: literalSegment.content.text) else {
            throw URLMacroError.malformedURL("\(argument)")
        }
        return "URL(string: \(argument))!"
    }
}
