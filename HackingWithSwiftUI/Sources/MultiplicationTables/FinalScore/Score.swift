//
//  Score.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 02.08.2023.
//

import Foundation

public struct Score: Equatable {
    public let score: Int
    public let questionsCount: Int
    public let message: String
    
    static let sample = Self(
        score: 5,
        questionsCount: 10,
        message: "This is good score!"
    )
    
    public init(
        score: Int,
        questionsCount: Int,
        message: String
    ) {
        self.score = score
        self.questionsCount = questionsCount
        self.message = message
    }
}
