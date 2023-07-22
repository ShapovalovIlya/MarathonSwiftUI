//
//  WeaponType.swift
//  
//
//  Created by Илья Шаповалов on 21.07.2023.
//

import Foundation

public enum WeaponType: String, CaseIterable, Identifiable {
    case rock
    case paper
    case scissors
    
    var weakness: WeaponType {
        switch self {
        case .rock: return .paper
        case .paper: return .scissors
        case .scissors: return .rock
        }
    }
    
    var imageName: String {
        switch self {
        case .rock: return "mountain.2.fill"
        case .paper: return "newspaper.fill"
        case .scissors: return "scissors"
        }
    }
    
    public var id: String {
        rawValue
    }
}
