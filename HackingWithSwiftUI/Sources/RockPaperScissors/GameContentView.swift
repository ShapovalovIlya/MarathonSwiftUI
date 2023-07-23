//
//  GameContentView.swift
//  
//
//  Created by Илья Шаповалов on 23.07.2023.
//

import SwiftUI
import SwiftUDF

struct GameContentView: View {
    @ObservedObject var store: StoreOf<RockPaperScissorsDomain>
    
    private let gameOverTransition: AnyTransition = .slide
    private let rockPaperScissorsTransition: AnyTransition = .move(edge: .top)
    
    var body: some View {
        ZStack {
            GameBackground()
                .ignoresSafeArea()
            Group {
                switch store.isPlayingGame {
                case true:
                    RockPaperScissorsView(store: store)
                        .transition(rockPaperScissorsTransition)
                case false:
                    TemplateView(
                        title: store.alertTitle,
                        description: store.alertDescription,
                        playAgain: { store.send(.setupRound) })
                    .transition(gameOverTransition)
                }
            }
            .animation(.easeInOut, value: store.isPlayingGame)
        }
        .toolbar(.hidden, for: .tabBar)
        .alert(
            store.alertTitle,
            isPresented:  Binding(
                get: { store.isAlertShown },
                set: { _ in store.send(.dismissAlert) })
        ) {
            Button(
                "Continue",
                role: .cancel,
                action: { store.send(.setupRound) })
        } message: {
            Text(store.alertDescription)
        }
    }
}

struct GameContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            GameContentView(store: RockPaperScissorsDomain.previewStore)
        }
        .previewDisplayName("Default state")
        NavigationStack {
            GameContentView(store: RockPaperScissorsDomain.previewStoreGameState)
        }
        .previewDisplayName("Game state")
        NavigationStack {
            GameContentView(store: RockPaperScissorsDomain.previewStoreGameOverState)
        }
        .previewDisplayName("Game over state")
        NavigationStack {
            GameContentView(store: RockPaperScissorsDomain.previewStoreAlertState)
        }
        .previewDisplayName("Alert state")
    }
}
