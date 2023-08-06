//
//  FileManager.swift
//
//
//  Created by Илья Шаповалов on 25.07.2023.
//

import Foundation
import Combine
import Shared
import OSLog

public struct FileManager {
    public static let shared = FileManager()
    private let decoder: JSONDecoder
    private let logger = Logger(
        subsystem: Bundle.module.bundleIdentifier!,
        category: String(describing: Self.self)
    )
    
    private init() {
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        logger.debug("Initialized.")
    }
    
    public func getData<T: Decodable>(from file: String) -> AnyPublisher<T, Error> {
        logger.debug("Decoding \(String(describing: T.self)) from \(file)")
        return load(file)
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
        logger.debug("Loading file: \(file)")
        return Bundle.module.url(forResource: file, withExtension: withExtension)
            .publisher
            .tryMap(tryUnwrap(url:))
            .tryMap(getData(from:))
            .eraseToAnyPublisher()
    }
    
    private func tryUnwrap(url: URL?) throws -> URL {
        guard let url = url else {
            throw CocoaError(.fileNoSuchFile)
        }
        return url
    }
    
    private func getData(from url: URL) throws -> Data {
        try Data(contentsOf: url)
    }
}
