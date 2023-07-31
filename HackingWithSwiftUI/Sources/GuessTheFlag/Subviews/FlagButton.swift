//
//  FlagButton.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 31.07.2023.
//

import SwiftUI

struct FlagButton: View {
    let flag: String
    let action: () -> Void
    
    @State private var animationAmount = 0.0
    
    var body: some View {
        Button {
            withAnimation(.easeIn(duration: 1)) {
                action()
                animationAmount += 360
            }
        } label: {
            FlagImage(flag)
        }
        .rotation3DEffect(
            .degrees(animationAmount),
            axis: (x: 0.0, y: 1.0, z: 0.0)
        )
    }
    
    init(
        _ flag: String,
        action: @escaping () -> Void
    ) {
        self.flag = flag
        self.action = action
    }
}

#Preview {
    FlagButton(
        "Russia",
        action: {})
    .frame(width: 200, height: 150)
}