//
//  GameBackground.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 31.07.2023.
//

import SwiftUI

struct GameBackground: View {
    var body: some View {
        RadialGradient(
            stops: [
                .init(
                    color: .init(red: 0.1, green: 0.2, blue: 0.45),
                    location: 0.3),
                .init(
                    color: .init(red: 0.76, green: 0.15, blue: 0.26),
                    location: 0.3)
            ],
            center: .top,
            startRadius: 200,
            endRadius: 400)
        .ignoresSafeArea()
    }
}

#Preview {
    GameBackground()
}
