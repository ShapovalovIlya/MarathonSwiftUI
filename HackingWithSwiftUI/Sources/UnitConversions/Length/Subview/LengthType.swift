//
//  File.swift
//  
//
//  Created by User on 19.07.2023.
//

import Foundation

public enum LengthType: String, CaseIterable, Identifiable {
    case meters, kilometers, feet, yards, miles
    
    var unit: UnitLength {
        switch self {
        case .meters: return .meters
        case .kilometers: return .kilometers
        case .feet: return .feet
        case .yards: return .yards
        case .miles: return .miles
        }
    }
    
    public var id: String {
        rawValue
    }
}
