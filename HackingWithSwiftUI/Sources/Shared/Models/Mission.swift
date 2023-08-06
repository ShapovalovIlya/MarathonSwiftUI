//
//  Mission.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 05.08.2023.
//

import Foundation

public struct Mission: Identifiable, Codable, Equatable {
    public let id: Int
    public let launchDate: Date?
    public let crew: [CrewRole]
    public let description: String
    
    public var displayName: String {
        "Apollo \(id)"
    }
    
    public var image: String {
        "apollo\(id)"
    }
    
    public var formattedLaunchDate: String {
        launchDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A"
    }
    
    public init(
        id: Int,
        launchDate: Date?,
        crew: [CrewRole],
        description: String
    ) {
        self.id = id
        self.launchDate = launchDate
        self.crew = crew
        self.description = description
    }
    
    public static let sample: [Mission] = [
        .init(id: 1, launchDate: .now, crew: CrewRole.sample, description: "First one"),
        .init(id: 7, launchDate: .distantPast, crew: CrewRole.sample, description: "Second one"),
        .init(id: 8, launchDate: .distantFuture, crew: CrewRole.sample, description: "Third one")
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
