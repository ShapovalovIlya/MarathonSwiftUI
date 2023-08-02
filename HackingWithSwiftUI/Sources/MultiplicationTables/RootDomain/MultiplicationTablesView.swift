//
//  MultiplicationTablesView.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 01.08.2023.
//

import SwiftUI
import SwiftUDF

public struct MultiplicationTablesView: View {
    @StateObject private var store = RootDomain.previewStore
    private let transition: AnyTransition = .asymmetric(
        insertion: .move(edge: .top),
        removal: .opacity
    )
    
    public var body: some View {
        ZStack {
            GameBackground()
                .ignoresSafeArea()
            Group {
                switch store.state {
                case .settings:
                    SettingsView(onCommit: { store.send(.commitSettings($0)) })
                    .padding()
                    
                case let .game(initialState):
                    GameView(
                        initialState: initialState,
                        onCommit: { store.send(.commitGameResult($0)) }
                    )
                    
                case let .score(score):
                    FinalScoreView(
                        score,
                        playAgainTap: { store.send(.playAgainButtonTap) }
                    )
                }
            }
            .animation(
                .easeInOut(duration: 1),
                value: store.state
            )
            .transition(transition)
        }
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem {
                Button("Restart game") {
                    store.send(.playAgainButtonTap)
                }
            }
        }
    }
    
    public init() {}
    
}

#Preview {
    NavigationStack {
        MultiplicationTablesView()
    }
}
