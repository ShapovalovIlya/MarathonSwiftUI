//
//  VolumeBackground.swift
//  
//
//  Created by User on 20.07.2023.
//

import SwiftUI

struct VolumeBackground: View {
    var body: some View {
        LinearGradient(
            gradient: .init(colors: [
                .blue,
                .green,
                .purple
                ]),
            startPoint: .top,
            endPoint: .bottom)
        .overlay(Material.ultraThinMaterial)
    }
}

struct VolumeBackground_Previews: PreviewProvider {
    static var previews: some View {
        VolumeBackground()
    }
}
