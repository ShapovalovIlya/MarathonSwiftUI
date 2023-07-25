//
//  FileManager.swift
//
//
//  Created by Илья Шаповалов on 25.07.2023.
//

import Foundation
import Combine

public struct FileManager {
    public static func loadResources() -> AnyPublisher<[String], Never> {
        Bundle.module.url(forResource: "start", withExtension: "txt")
            .publisher
            .map(String.init)
            .map({ $0.components(separatedBy: "\n") })
            .eraseToAnyPublisher()
    }
}
