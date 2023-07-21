//
//  SwiftUIView.swift
//  
//
//  Created by User on 19.07.2023.
//

import SwiftUI

struct BackgroundGradient: View {
    var body: some View {
        AngularGradient(
            gradient: .init(colors: [
                .red,
                .orange,
                .yellow,
                .green,
                .blue,
                .purple
            ]),
            center: .center)
        .overlay(.ultraThinMaterial)
    }
}

struct BackgroundGradient_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundGradient()
    }
}
