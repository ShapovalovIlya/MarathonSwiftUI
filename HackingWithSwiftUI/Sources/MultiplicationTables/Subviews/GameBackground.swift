//
//  GameBackground.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 03.08.2023.
//

import SwiftUI

struct GameBackground: View {
    var body: some View {
        LinearGradient(
            gradient: .init(colors: [
                .red,
                .green,
                .blue
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

#Preview {
    GameBackground()
}
