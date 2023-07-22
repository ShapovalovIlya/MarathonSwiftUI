//
//  GameBackground.swift
//  
//
//  Created by Илья Шаповалов on 23.07.2023.
//

import SwiftUI

struct GameBackground: View {
    var body: some View {
        LinearGradient(
            gradient: .init(colors: [
                .purple,
                .blue,
                .cyan,
                .green
            ]),
            startPoint: .topTrailing,
            endPoint: .bottomLeading)
        .overlay(Material.ultraThinMaterial.opacity(0.5))
    }
}

struct GameBackgroundw_Previews: PreviewProvider {
    static var previews: some View {
        GameBackground()
    }
}
