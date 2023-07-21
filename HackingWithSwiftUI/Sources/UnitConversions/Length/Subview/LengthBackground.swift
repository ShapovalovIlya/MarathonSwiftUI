//
//  LengthBackground.swift
//  
//
//  Created by Илья Шаповалов on 21.07.2023.
//

import SwiftUI

struct LengthBackground: View {
    var body: some View {
        LinearGradient(
            gradient: .init(
                colors: [
                    .cyan,
                    .blue,
                    .purple,
                    .indigo
                ]),
            startPoint: .bottomLeading,
            endPoint: .topTrailing)
        .overlay(Material.ultraThinMaterial)
    }
}

struct LengthBackground_Previews: PreviewProvider {
    static var previews: some View {
        LengthBackground()
    }
}
