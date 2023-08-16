//
//  DrawingView.swift
//  
//
//  Created by Илья Шаповалов on 14.08.2023.
//

import SwiftUI

public struct DrawingView: View {
    @State var petalOffset = -20.0
    @State var petalWidth = 100.0
    @State var colorCycle = 0.0
    @State var insetAmount = 0.0
    
    public var body: some View {
        VStack {
//            ColorCyclingCircle(amount: colorCycle)
//                .frame(width: 300, height: 300)
//            Slider(value: $colorCycle)
            Trapezoid(insetAmount: insetAmount)
                .frame(width: 200, height: 100)
                .onTapGesture {
                    withAnimation {
                        insetAmount = Double.random(in: 10...90)
                    }
                }
        }
    }
    
    public init() {}
}

#Preview {
    DrawingView()
}
