//
//  Transitions.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 30.07.2023.
//

import SwiftUI

struct Transitions: View {
    @State var isShowingRect = false
    
    var transition: AnyTransition {
        .asymmetric(
            insertion: .scale,
            removal: .opacity
        )
    }
    
    var body: some View {
        VStack {
            Button("Tap me") {
                withAnimation {
                    isShowingRect.toggle()
                }
            }
            if isShowingRect {
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 200, height: 200)
                    .transition(.pivot)
            }
        }
    }
}

#Preview {
    Transitions()
}
