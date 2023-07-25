//
//  FileManager.swift
//
//
//  Created by Илья Шаповалов on 25.07.2023.
//

import Foundation
import Combine

public struct FileManager {
    public static func loadResources() -> AnyPublisher<[String], Error> {
        Bundle.module.url(forResource: "start", withExtension: "txt")
            .publisher
            .tryMap(String.init(contentsOf:))
            .map({ $0.components(separatedBy: "\n") })
            .eraseToAnyPublisher()
    }
}
