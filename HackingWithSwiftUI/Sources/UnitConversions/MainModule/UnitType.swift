//
//  File.swift
//  
//
//  Created by User on 18.07.2023.
//

import Foundation

public enum UnitTypes: String, CaseIterable, Identifiable {
    case temperature
    case length
    case time
    case volume
    
    public var id: String {
        rawValue
    }
    
    public var imageName: String {
        switch self {
        case .temperature: return "thermometer.sun.circle"
        case .length: return "ruler"
        case .time: return "clock.arrow.2.circlepath"
        case .volume: return "percent"
        }
    }
}
