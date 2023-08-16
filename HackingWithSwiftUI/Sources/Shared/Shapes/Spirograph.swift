//
//  SwiftUIView.swift
//  
//
//  Created by Илья Шаповалов on 15.08.2023.
//

import SwiftUI

public struct Spirograph: Shape {
    let innerRadius: Double
    let outerRadius: Double
    let distance: Double
    let amount: Double
    
    public func path(in rect: CGRect) -> Path {
        let divisor = gcd(innerRadius, outerRadius)
        let difference = innerRadius - outerRadius
        let endPoint = ceil(2 * Double.pi * outerRadius / divisor) * amount
        
        var path = Path()
        
        stride(from: 0, through: endPoint, by: 0.01)
            .forEach { theta in
                var x = difference * cos(theta) + distance * cos(difference / outerRadius * theta)
                var y = difference * sin(theta) - distance * sin(difference / outerRadius * theta)
                
                x += rect.width / 2
                y += rect.height / 2
                
                if theta == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
        
        return path
    }
    
    public init(
        innerRadius: Double,
        outerRadius: Double,
        distance: Double,
        amount: Double
    ) {
        self.innerRadius = innerRadius
        self.outerRadius = outerRadius
        self.distance = distance
        self.amount = amount
    }
    
    private func gcd(_ a: Double, _ b: Double) -> Double {
        var a = a
        var b = b
        
        while b != 0 {
            let temp = b
            b = a.truncatingRemainder(dividingBy: b)
            a = temp
        }
        
        return a
    }
    
}

//#Preview {
//    Spirograph(innerRadius: 1, outerRadius: 1, distance: 1, amount: 1)
//}
