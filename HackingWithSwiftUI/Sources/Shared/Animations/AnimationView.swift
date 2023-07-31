//
//  AnimationView.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 29.07.2023.
//

import SwiftUI

struct AnimationView: View {
    @State private var animationAmount = 1.0
    
    var body: some View {
        print(animationAmount)
        
        return VStack {
            Stepper(
                "Scale amount",
                value: $animationAmount.animation(),
                in: 1...10
            )
            Spacer()
            Button("Tap me") {
                animationAmount += 1
            }
            .padding(40)
            .background(Color.red)
            .foregroundStyle(Color.white)
            .clipShape(Circle())
            .scaleEffect(animationAmount)
        }
        .padding()
    }
}

#Preview {
    AnimationView()
}
