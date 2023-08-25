//
//  PushButton.swift
//  
//
//  Created by Илья Шаповалов on 25.08.2023.
//

import SwiftUI

public struct PushButton: View {
    private let onColors: [Color] = [.red, .yellow]
    private let offColors: [Color] = [.init(white: 0.6), .init(white: 0.4)]
    private let title: String
    @Binding private var isOn: Bool
    
    public var body: some View {
        Button(title) {
            isOn.toggle()
        }
        .padding()
        .background(
            LinearGradient(
                gradient: .init(colors: isOn ? onColors : offColors),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .foregroundStyle(.white)
        .clipShape(Capsule())
        .shadow(radius: isOn ? 0 : 5)
    }
    
    public init(title: String, isOn: Binding<Bool>) {
        self.title = title
        self._isOn = isOn
    }
}

#Preview {
    VStack {
        PushButton(title: "Title 1", isOn: .constant(true))
        PushButton(title: "Title 2", isOn: .constant(false))
    }
}
