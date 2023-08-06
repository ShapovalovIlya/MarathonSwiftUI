//
//  Mission.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 05.08.2023.
//

import Foundation

public struct Mission: Identifiable, Codable, Equatable {
    public let id: Int
    public let launchDate: String?
    public let crew: [CrewRole]
    public let description: String
    
    public init(
        id: Int,
        launchDate: String?,
        crew: [CrewRole],
        description: String
    ) {
        self.id = id
        self.launchDate = launchDate
        self.crew = crew
        self.description = description
    }
    
    public static let sample: [Mission] = [
        .init(id: 1, launchDate: "01.01.1970", crew: CrewRole.sample, description: "First one"),
        .init(id: 1, launchDate: "01.01.1980", crew: CrewRole.sample, description: "Second one"),
        .init(id: 1, launchDate: "01.01.1990", crew: CrewRole.sample, description: "Third one")
    ]
}

public extension Mission {
    struct CrewRole: Codable, Equatable {
        public let name: String
        public let role: String
        
        public init(name: String, role: String) {
            self.name = name
            self.role = role
        }
        
        public static let sample: [CrewRole] = [
            .init(name: "Eminem", role: "MC"),
            .init(name: "Dr.Dre", role: "MC"),
            .init(name: "Woodkid", role: "Musician")
        ]
    }
}
