//
//  VolumeType.swift
//  
//
//  Created by User on 20.07.2023.
//

import Foundation

public enum VolumeType: String, CaseIterable, Identifiable {
    case milliliters, liters, cups, pints, gallons
    
    var unit: UnitVolume {
        switch self {
        case .milliliters: return .milliliters
        case .liters: return .liters
        case .pints: return .pints
        case .gallons: return .gallons
        case .cups: return .cups
        }
    }
    
    public var id: String {
        rawValue
    }
}
