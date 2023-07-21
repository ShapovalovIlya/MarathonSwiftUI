//
//  File.swift
//  
//
//  Created by User on 19.07.2023.
//

import Foundation

public enum TimeType: String, CaseIterable, Identifiable {
    case seconds, minutes, hours, milliseconds
    
    var unit: UnitDuration {
        switch self {
        case .seconds: return .seconds
        case .minutes: return .minutes
        case .hours: return .hours
        case .milliseconds: return .milliseconds
        }
    }
    
   public  var id: String {
        rawValue
    }
}
