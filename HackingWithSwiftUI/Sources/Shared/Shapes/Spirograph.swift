//
//  SwiftUIView.swift
//  
//
//  Created by Илья Шаповалов on 15.08.2023.
//

import SwiftUI

public struct Spirograph: Shape {
    let innerRadius: Int
    let outerRadius: Int
    let distance: Int
    let amount: Double
    
    public func path(in rect: CGRect) -> Path {
        let divisor = gcd(innerRadius, outerRadius)
        let outerRadius = Double(self.outerRadius)
        let innerRadius = Double(self.innerRadius)
        let distance = Double(self.distance)
        let difference = innerRadius - outerRadius
        let endPoint = ceil(2 * Double.pi * outerRadius / Double(divisor)) * amount
        
        
        
        return Path { path in
            
        }
    }
    
    public init(innerRadius: Int, outerRadius: Int, distance: Int, amount: Double) {
        self.innerRadius = innerRadius
        self.outerRadius = outerRadius
        self.distance = distance
        self.amount = amount
    }
    
    private func gcd(_ a: Int, _ b: Int) -> Int {
        var a = a
        var b = b
        
        while b != 0 {
            let temp = b
            b = a % b
            a = temp
        }
        
        return a
    }
    
}

//#Preview {
//    Spirograph(innerRadius: 1, outerRadius: 1, distance: 1, amount: 1)
//}
