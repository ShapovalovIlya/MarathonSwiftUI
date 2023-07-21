//
//  TimeBackground.swift
//  
//
//  Created by User on 20.07.2023.
//

import SwiftUI

struct TimeBackground: View {
    
    var body: some View {
        LinearGradient(
            gradient: .init(
                colors: [
                    .purple,
                    .yellow,
                    .green
                ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
        .overlay(Material.ultraThinMaterial)
    }
}

struct TimeBackground_Previews: PreviewProvider {
    static var previews: some View {
        TimeBackground()
    }
}
