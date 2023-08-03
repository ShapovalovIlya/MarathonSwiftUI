//
//  UserDefaultsClient.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 03.08.2023.
//

import Foundation
import Shared
import Combine

public struct UserDefaultsClient {
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
}
