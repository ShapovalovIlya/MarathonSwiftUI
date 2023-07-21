//
//  File.swift
//  
//
//  Created by User on 19.07.2023.
//

import Foundation

public enum TemperatureType: Int, CaseIterable, Identifiable {
    case celsius
    case fahrenheit
    case kelvin
    
    var unit: UnitTemperature {
        switch self {
        case .celsius: return .celsius
        case .fahrenheit: return .fahrenheit
        case .kelvin: return .kelvin
        }
    }
    
    public var id: Int {
        rawValue
    }
}
