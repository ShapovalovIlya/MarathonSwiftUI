//
//  MyMacroPlugin.swift
//  
//
//  Created by Илья Шаповалов on 28.07.2023.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MyMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        StringifyMacro.self,
        URLMacro.self,
    ]
}
