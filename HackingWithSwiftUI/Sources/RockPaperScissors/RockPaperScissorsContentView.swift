//
//  RockPaperScissorsContentView.swift
//  
//
//  Created by Илья Шаповалов on 23.07.2023.
//

import SwiftUI
import SwiftUDF

public struct RockPaperScissorsContentView: View {
    @ObservedObject var store: StoreOf<RockPaperScissorsDomain>
    
    private let gameOverTransition: AnyTransition = .slide
    private let rockPaperScissorsTransition: AnyTransition = .move(edge: .top)
    
    public var body: some View {
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
                        play: { store.send(.setupRound) })
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
    
    public init(store: StoreOf<RockPaperScissorsDomain>) {
        self.store = store
    }
    
}

struct GameContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RockPaperScissorsContentView(store: RockPaperScissorsDomain.previewStore)
        }
        .previewDisplayName("Default state")
        NavigationStack {
            RockPaperScissorsContentView(store: RockPaperScissorsDomain.previewStoreGameState)
        }
        .previewDisplayName("Game state")
        NavigationStack {
            RockPaperScissorsContentView(store: RockPaperScissorsDomain.previewStoreGameOverState)
        }
        .previewDisplayName("Game over state")
        NavigationStack {
            RockPaperScissorsContentView(store: RockPaperScissorsDomain.previewStoreAlertState)
        }
        .previewDisplayName("Alert state")
    }
}
