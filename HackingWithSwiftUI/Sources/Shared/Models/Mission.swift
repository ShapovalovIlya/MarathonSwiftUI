//
//  Mission.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 05.08.2023.
//

import Foundation

public struct Mission: Identifiable, Codable {
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
}

public extension Mission {
    struct CrewRole: Codable {
        public let name: String
        public let role: String
        
        public init(name: String, role: String) {
            self.name = name
            self.role = role
        }
    }
}
