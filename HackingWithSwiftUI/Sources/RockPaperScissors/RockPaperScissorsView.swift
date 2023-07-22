//
//  RockPaperScissorsView.swift
//  
//
//  Created by Илья Шаповалов on 23.07.2023.
//

import SwiftUI
import SwiftUDF
import Shared

public struct RockPaperScissorsView: View {
    @ObservedObject public var store: StoreOf<RockPaperScissorsDomain>
    
    private struct Drawing {
        static let buttonsSpacing: CGFloat = 5
    }
    
    public var body: some View {
        ZStack {
            GameBackground()
                .ignoresSafeArea()
            VStack {
                GameText(text: "Score: \(store.score)")
                    .equatable()
                Spacer()
                EnemyWeaponLabel(weapon: store.enemyWeapon)
                    .equatable()
                GameText(text: store.gameExpectation.prompt)
                Spacer()
                HStack(spacing: Drawing.buttonsSpacing) {
                    ForEach(WeaponType.allCases.shuffled()) { weapon in
                        WeaponButton(
                            type: weapon,
                            action: { store.send(.playerChooseWeapon($0)) })
                        .equatable()
                    }
                }
            }
            .padding()
        }
        .onAppear { store.send(.setupRound) }
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

struct RockPaperScissorsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RockPaperScissorsView(store: RockPaperScissorsDomain.previewStore)
        }
    }
}
