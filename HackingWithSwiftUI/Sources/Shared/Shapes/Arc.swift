//
//  Arc.swift
//
//
//  Created by Илья Шаповалов on 14.08.2023.
//

import SwiftUI

public struct Arc: Shape, InsettableShape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool
    var insetAmount: CGFloat = .init()
    
    public func path(in rect: CGRect) -> Path {
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStartAngle = startAngle - rotationAdjustment
        let modifiedEndAngle = endAngle - rotationAdjustment
        
        var path = Path()
        path.addArc(
            center: CGPoint(x: rect.midX, y: rect.midY),
            radius: rect.width * 0.5 - insetAmount,
            startAngle: modifiedStartAngle,
            endAngle: modifiedEndAngle,
            clockwise: !clockwise)
        
        return path
    }
    
    public func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }
}
