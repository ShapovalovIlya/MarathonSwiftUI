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
    
    public init(
        id: UUID = .init(),
        name: String,
        type: ExpenseType,
        amount: Double
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.amount = amount
    }
}

extension ExpenseItem {
    public enum ExpenseType: String, Equatable, CaseIterable, Codable {
        case business, personal
    }
    
    public static let sample: [ExpenseItem] = [
        .init(name: "Coffee", type: .personal, amount: 10),
        .init(name: "Toilet paper", type: .business, amount: 2),
        .init(name: "Sweet roll", type: .personal, amount: 5)
    ]
}
