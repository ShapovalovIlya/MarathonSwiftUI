//
//  FileManager.swift
//
//
//  Created by Илья Шаповалов on 25.07.2023.
//

import Foundation
import Combine
import Shared

public struct FileManager {
    public static let shared = FileManager()
    private let decoder: JSONDecoder
    
    private init() {
        decoder = JSONDecoder()
    }
    
    public func getData<T: Decodable>(from file: String) -> AnyPublisher<T, Error> {
        load(file)
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    public func loadResources() -> AnyPublisher<[String], Error> {
        Bundle.module.url(forResource: "start", withExtension: "txt")
            .publisher
            .tryMap(String.init(contentsOf:))
            .map({ $0.components(separatedBy: "\n") })
            .eraseToAnyPublisher()
    }
    
    private func load(_ file: String, withExtension: String? = nil) -> AnyPublisher<Data, Error> {
        Bundle.module.url(forResource: file, withExtension: withExtension)
            .publisher
            .compactMap({ $0 })
            .tryMap(Data.init)
            .eraseToAnyPublisher()
    }
}
