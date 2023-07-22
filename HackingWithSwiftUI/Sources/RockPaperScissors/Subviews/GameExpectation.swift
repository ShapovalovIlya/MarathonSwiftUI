//
//  File.swift
//  
//
//  Created by Илья Шаповалов on 22.07.2023.
//

import Foundation

public enum GameExpectation: String, Equatable, CaseIterable {
    case playerWin, playerLoose, draw
    
    var prompt: String {
        switch self {
        case .playerWin: return "You should win!"
        case .playerLoose: return "You should loose!"
        case .draw: return "We need a draw!"
        }
    }
}
