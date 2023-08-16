//
//  FlowerShape.swift
//  
//
//  Created by Илья Шаповалов on 14.08.2023.
//

import SwiftUI

public struct Flower: Shape {
    let petalOffset: Double
    let petalWidth: Double
    
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        
        for number in stride(
            from: 0,
            to: Double.pi * 2,
            by: Double.pi * 0.2
        ) {
            let rotation = CGAffineTransform(rotationAngle: number)
            let position = rotation.concatenating(
                CGAffineTransform(translationX: rect.width * 0.5, y: rect.height * 0.5)
            )
            let originalPetal = Path(
                ellipseIn: CGRect(
                    x: petalOffset,
                    y: 0,
                    width: petalWidth,
                    height: rect.width * 0.5)
            )
            let rotatedPetal = originalPetal.applying(position)
            path.addPath(rotatedPetal)
        }
        
        return path
    }
    
    public init(
        petalOffset: Double = -20,
        petalWidth: Double = 100
    ) {
        self.petalOffset = petalOffset
        self.petalWidth = petalWidth
    }
}

#Preview {
    Flower()
}
