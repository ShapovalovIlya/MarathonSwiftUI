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
        VStack {
            GameText(text: "Score: \(store.score)")
                .equatable()
            Spacer()
            EnemyWeaponLabel(weapon: store.enemyWeapon)
                .equatable()
            
            GameText(text: store.gameExpectation.prompt)
                .equatable()
                .animation(.easeInOut, value: store.currentRound)
            
            Spacer()
            HStack(spacing: Drawing.buttonsSpacing) {
                ForEach(store.armory) { weapon in
                    WeaponButton(
                        type: weapon,
                        action: { store.send(.playerChooseWeapon($0)) })
                    .equatable()
                }
            }
            .animation(.easeInOut, value: store.currentRound)
        }
        .padding()
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
