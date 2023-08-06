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
        "Eminem": .init(id: "aldrin", name: "Eminem", description: "MC"),
        "Dr.Dre": .init(id: "anders", name: "Dr.Dre", description: "Producer"),
        "Woodkid": .init(id: "armstrong", name: "Woodkid", description: "Musician")
    ]
}
