//
//  DragAnimations.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 29.07.2023.
//

import SwiftUI

struct DragAnimations: View {
    @State private var dragAmount: CGSize = .zero
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { dragAmount = $0.translation }
            .onEnded { _ in
                withAnimation(.spring()) {
                    dragAmount = .zero
                }
            }
    }
    
    var body: some View {
        LinearGradient(
            gradient: .init(colors: [
                .yellow,
                .red,
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .frame(width: 300, height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .offset(dragAmount)
        .gesture(drag)
    }
}

#Preview("Drag card") {
    DragAnimations()
}

struct HelloSwiftUIDrag: View {
    let letters = Array("Hello SwiftUI")
    @State var enabled = false
    @State var dragAmount: CGSize = .zero
    
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { dragAmount = $0.translation }
            .onEnded { _ in
                dragAmount = .zero
                enabled.toggle()
            }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<letters.count, id: \.self) { num in
                Text(letters[num].description)
                    .padding(5)
                    .font(.title)
                    .background(enabled ? .blue : .red)
                    .offset(dragAmount)
                    .animation(
                        .default.delay(Double(num) / 20),
                        value: dragAmount
                    )
            }
        }
        .gesture(dragGesture)
    }
}

#Preview("Hello SwiftUI") {
    HelloSwiftUIDrag()
}
