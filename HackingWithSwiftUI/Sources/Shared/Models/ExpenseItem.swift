//
//  ExpenseItem.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 03.08.2023.
//

import Foundation

public struct ExpenseItem: Identifiable, Equatable, Codable {
    public let id: UUID
    public let name: String
    public let type: ExpenseType
    public let amount: Double
    public let currency: String
    
    public init(
        id: UUID = .init(),
        name: String,
        type: ExpenseType,
        amount: Double,
        currency: String
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.amount = amount
        self.currency = currency
    }
}

extension ExpenseItem {
    public enum ExpenseType: String, Equatable, CaseIterable, Codable {
        case business, personal
    }
    
    public static let sample: [ExpenseItem] = [
        .init(name: "Coffee", type: .personal, amount: 10, currency: "USD"),
        .init(name: "Toilet paper", type: .business, amount: 2, currency: "RUB"),
        .init(name: "Sweet roll", type: .personal, amount: 5, currency: "EUR")
    ]
}
