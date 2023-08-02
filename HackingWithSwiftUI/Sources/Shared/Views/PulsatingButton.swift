//
//  PulsatingButton.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 03.08.2023.
//

import SwiftUI

public struct PulsatingButton: View, Equatable {
    let title: String
    let action: () -> Void
    let textColor: Color
    let backgroundColor: Color
    
    @State private var animationAmount = 1.0
    
    public var body: some View {
        Button(title) {
            animationAmount = 1
            withAnimation(.easeInOut) {
                animationAmount = 2
                action()
            }
        }
        .bold()
        .padding()
        .background(backgroundColor)
        .foregroundStyle(textColor)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(backgroundColor)
                .scaleEffect(animationAmount)
                .opacity(2 - animationAmount)
        )
        .shadow(radius: 5)
    }
    
    public init(
        title: String,
        action: @escaping () -> Void,
        textColor: Color = .white,
        backgroundColor: Color = .blue
    ) {
        self.title = title
        self.action = action
        self.textColor = textColor
        self.backgroundColor = backgroundColor
    }
    
    public static func == (lhs: PulsatingButton, rhs: PulsatingButton) -> Bool {
        return lhs.title == rhs.title &&
        lhs.textColor == rhs.textColor &&
        lhs.backgroundColor == rhs.backgroundColor &&
        lhs.animationAmount == rhs.animationAmount
    }
}

#Preview {
    PulsatingButton(title: "Tap me", action: {})
}
