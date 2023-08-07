//
//  AstronautView.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 07.08.2023.
//

import SwiftUI
import Shared

struct AstronautView: View {
    let astronaut: Astronaut
    
    var body: some View {
        ScrollView {
            VStack {
                MoonshotImage(name: astronaut.id)
                
                Text(astronaut.description)
                    .padding()
            }
        }
        .background(.darkBackground)
        .navigationTitle(astronaut.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        AstronautView(astronaut: .sample.values.first!)
            .preferredColorScheme(.dark)
    }
}
