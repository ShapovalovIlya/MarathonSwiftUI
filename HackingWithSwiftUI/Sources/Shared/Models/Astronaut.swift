//
//  Astronaut.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 05.08.2023.
//

import Foundation

public struct Astronaut: Codable, Identifiable, Equatable {
    public let id: String
    public let name: String
    public let description: String
    
    public init(id: String, name: String, description: String) {
        self.id = id
        self.name = name
        self.description = description
    }
    
    public static let sample: [String: Astronaut] = [
        "Bags Bunny": .init(id: "first_id", name: "Bags Bunny", description: "What's up doc?"),
        "Batman": .init(id: "second_id", name: "Batman", description: "I am the night!"),
        "Lizard": .init(id: "third_id", name: "Lizard", description: "I don't give you the stone.")
    ]
}
