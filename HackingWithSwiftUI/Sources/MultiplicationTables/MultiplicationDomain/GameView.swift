//
//  GameView.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 01.08.2023.
//

import SwiftUI
import SwiftUDF
import Shared

struct GameView: View {
    private struct Drawing {
        static let cornerRadius: CGFloat = 12
    }
    
    @ObservedObject var store: StoreOf<GameDomain>
    let onCommit: (GameDomain.State) -> Void
    
    var body: some View {
        VStack {
            Text("Type right answer")
                .font(.subheadline)
            Text("What is \(store.lhs) x \(store.rhs)?")
                .font(.title)
            NumberField(
                title: "Type answer...",
                binding: Binding(
                    get: { store.guess },
                    set: { store.send(.setGuess($0)) }
                )
            )
            .equatable()
            RoundedRectangleButton(
                title: "Resolve",
                action: { store.send(.resolveButtonTap) },
                cornerRadius: Drawing.cornerRadius
            )
            .equatable()
        }
        .onAppear { store.send(.askQuestion) }
        .padding()
        .background(Material.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: Drawing.cornerRadius))
        .alert(
            store.alertTitle,
            isPresented: Binding(
                get: { store.isAlertShown },
                set: { _ in store.send(.dismissAlert) }
            )
        ) {
            Button("Continue") { store.send(.continueButtonTap) }
        }
        .alert(
            store.alertTitle,
            isPresented: Binding(
                get: { store.isGameOver },
                set: { _ in store.send(.dismissAlert) }
            )
        ) {
            Button("Score") { onCommit(store.state) }
        }
    }
}

#Preview("game state") {
    ZStack {
        Color.blue
        GameView(store: GameDomain.previewStore, onCommit: { _ in })
    }
}

#Preview("alert state") {
    ZStack {
        Color.red
        GameView(store: GameDomain.previewStoreAlertState, onCommit: { _ in })
    }
}

#Preview("game over state") {
    ZStack {
        Color.cyan
        GameView(store: GameDomain.previewStoreGameOverState, onCommit: { _ in })
    }
}
