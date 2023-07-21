//
//  File.swift
//  
//
//  Created by User on 19.07.2023.
//

import Foundation

public extension Double {
    func toUnitText(maximumFractionDigits: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.roundingMode = .halfUp
        formatter.maximumFractionDigits = maximumFractionDigits
        
        return formatter.string(from: self as NSNumber) ?? "???"
    }
}
