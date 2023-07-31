//
//  TapMeButton.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 28.07.2023.
//

import SwiftUI

//MARK: - First
struct TapMeButton: View {
    let action: () -> Void
    @State private var animationAmount = 1.0
    
    var body: some View {
        Button("Tap me") {
            action()
        }
        .padding(50)
        .background(Color.red)
        .foregroundStyle(Color.white)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(Color.red)
                .scaleEffect(animationAmount)
                .opacity(2 - animationAmount)
                .animation(
                    .easeInOut(duration: 1).repeatForever(autoreverses: false),
                    value: animationAmount
                )
        )
        .onAppear {
            animationAmount = 2
        }
    }
}

//MARK: - Second
struct SomeButton: View {
    @State private var animationAmount = 0.0
    
    var body: some View {
        Button("Tap me") {
            withAnimation(.interpolatingSpring(stiffness: 5, damping: 1)) {
                animationAmount += 360
            }
        }
        .padding(50)
        .background(Color.red)
        .foregroundStyle(Color.white)
        .clipShape(Circle())
        .rotation3DEffect(
            .degrees(animationAmount),
            axis: (x: 0.0, y: 1.0, z: 0.0)
        )
    }
}

struct AnotherButton: View {
    @State private var enabled = false
    
    var body: some View {
        Button("Tap Me") {
            enabled.toggle()
        }
        .frame(width: 200, height: 200)
        .background(enabled ? .blue : .red)
        .animation(.default, value: enabled)
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: enabled ? 60 : 0))
        .animation(
            .interpolatingSpring(stiffness: 10, damping: 1),
            value: enabled
        )
    }
}

#Preview("First") {
    TapMeButton(action: {})
}

#Preview("Second") {
    SomeButton()
}

#Preview("Third") {
    AnotherButton()
}
