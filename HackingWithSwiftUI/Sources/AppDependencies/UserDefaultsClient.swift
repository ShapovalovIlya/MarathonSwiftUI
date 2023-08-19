//
//  UserDefaultsClient.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 03.08.2023.
//

import Foundation
import Shared
import Combine
import SwiftFP
import OSLog

public struct UserDefaultsClient {
    private let logger = Logger(
        subsystem: Bundle.module.bundleIdentifier!,
        category: String(describing: Self.self)
    )
    public static let shared = Self()
    
    let userDefaults = UserDefaults.standard
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    let expensesKey = "expensesKey"
    
    private init() {}
    
    public func save(expenses: [ExpenseItem]) throws {
        let encoded = try encoder.encode(expenses)
        userDefaults.set(encoded, forKey: expensesKey)
    }
    
    public func loadExpenses() -> AnyPublisher<[ExpenseItem], Error> {
        userDefaults
            .data(forKey: expensesKey)
            .publisher
            .decode(type: [ExpenseItem].self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    public func getData<T: Decodable>(_ type: T) -> AnyPublisher<T, Error> {
        userDefaults.data(forKey: String(describing: type))
            .publisher
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    public func loadData<T: Decodable>(forKey key: String) -> AnyPublisher<T, Error> {
        logger.debug("Load \(String(describing: T.self)) for key \(key)")
        return compose(
            loadData(forKey: key),
            wrapToPublisher,
            decode(type: T.self)
        )(userDefaults)
    }
    
    public func saveModel<T: Encodable>(_ model: T, withKey key: String) throws {
        logger.debug("Save \(String(describing: model)) for key \(key)")
        return try tryCompose(
            encode(),
            saveData(forKey: key)
        )(model)
    }
}

private extension UserDefaultsClient {
    func decode<T: Decodable>(type: T.Type) -> (AnyPublisher<Data, Error>) -> AnyPublisher<T, Error> {
        {
            $0.decode(type: type, decoder: decoder)
                .eraseToAnyPublisher()
        }
    }
    
    func encode<T: Encodable>() -> (T) throws -> Data {
        { try JSONEncoder().encode($0) }
    }
    
    func wrapToPublisher(_ data: Data?) -> AnyPublisher<Data, Error> {
        Future { promise in
            if let data = data {
                promise(.success(data))
            } else {
                promise(.failure(CocoaError(.fileNoSuchFile)))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func loadData(forKey key: String) -> (UserDefaults) -> Data? {
        { $0.data(forKey: key) }
    }
    
    func saveData(forKey key: String) -> (Data) -> Void {
        { userDefaults.set($0, forKey: key) }
    }
}
