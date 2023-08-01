//
//  QuestionCount.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 01.08.2023.
//

import Foundation

enum QuestionCount: Int, CaseIterable, Identifiable {
    case five = 5
    case ten = 10
    case fifteen = 15
    case twentieth = 20
    
    var id: Int {
        rawValue
    }
}
