//
//  ColorCyclingCircle.swift
//  
//
//  Created by Илья Шаповалов on 14.08.2023.
//

import SwiftUI

public struct ColorCyclingCircle: View {
    let amount: Double
    let steps: Int
    
    public var body: some View {
        ZStack {
            ForEach(0..<steps) { value in
                Circle()
                    .inset(by: Double(value))
   //                 .strokeBorder(color(for: value, brightness: 1), lineWidth: 2)
                    .strokeBorder(
                        LinearGradient(
                            gradient: .init(
                                colors: [
                                    color(for: value, brightness: 1),
                                    color(for: value, brightness: 0.5)
                                ]),
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 2
                    )
            }
        }
        .drawingGroup()
    }
    
    private func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(steps) + amount
        
        if targetHue > 1 {
            targetHue -= 1
        }
        
        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
    
    public init(amount: Double = 0.0, steps: Int = 100) {
        self.amount = amount
        self.steps = steps
    }
}

#Preview {
    ColorCyclingCircle()
}
