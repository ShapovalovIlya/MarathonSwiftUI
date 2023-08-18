//
//  DrawingView.swift
//  
//
//  Created by Илья Шаповалов on 14.08.2023.
//

import SwiftUI

public struct DrawingView: View {
    @State private var innerRadius = 125.0
        @State private var outerRadius = 75.0
        @State private var distance = 25.0
        @State private var amount = 1.0
        @State private var hue = 0.6
    
    public var body: some View {
        Arrow()
//        VStack(spacing: 0) {
//            Spacer()
//            Spirograph(
//                innerRadius: innerRadius,
//                outerRadius: outerRadius,
//                distance: distance,
//                amount: amount
//            )
//            .stroke(
//                Color(hue: hue, saturation: 1, brightness: 1),
//                lineWidth: 1.0
//            )
//            .frame(width: 300, height: 300)
//            Spacer()
//            
//            Group {
//                Text("Inner radius \(Int(innerRadius))")
//                Slider(value: $innerRadius, in: 10...150, step: 1)
//                    .padding([.horizontal, .bottom])
//                
//                Text("Outer radius \(Int(outerRadius))")
//                Slider(value: $outerRadius, in: 10...150, step: 1)
//                    .padding([.horizontal, .bottom])
//                
//                Text("Distance \(Int(distance))")
//                Slider(value: $distance, in: 10...150, step: 1)
//                    .padding([.horizontal, .bottom])
//                
//                Text("Amount \(Int(amount), format: .number.precision(.fractionLength(2)))")
//                Slider(value: $amount)
//                    .padding([.horizontal, .bottom])
//                
//                Text("Color")
//                Slider(value: $hue)
//                    .padding(.horizontal)
//            }
//        }
    }
    
    public init() {}
}

#Preview {
    DrawingView()
}
