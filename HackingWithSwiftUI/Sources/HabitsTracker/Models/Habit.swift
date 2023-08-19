//
//  File.swift
//  
//
//  Created by Илья Шаповалов on 18.08.2023.
//

import Foundation

public struct Habit: Codable, Equatable, Identifiable {
    public var id: UUID = .init()
    public var title: String
    public var description: String
    public var count: Int
    
    public init(
        title: String,
        description: String,
        count: Int
    ) {
        self.title = title
        self.description = description
        self.count = count
    }
    
    static let sample: [Habit] = [
        .init(title: "First", description: "First description", count: 1),
        .init(title: "Second", description: "Second description", count: 2),
        .init(title: "Third", description: "Third description", count: 3)
    ]
}
