//
//  MessageGenerator.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 02.08.2023.
//

import Foundation
import Shared


public struct MessageGenerator {
    public static func compileMessage(_ score: Int, _ maxScore: Int) -> String {
        let result = Double(maxScore) / Double(score)
        print(result)
        switch result {
        case 1:
            return "You unbelievable!"
            
        case ...1.35:
            return "You are very good!"
            
        case ...2:
            return "You can handle math."
            
        default: return "Keep practice"
        }
    }
    
}
