//
//  GamesTab.swift
//  
//
//  Created by User on 18.07.2023.
//

import SwiftUI
import SwiftUDF
import GuessTheFlag
import RockPaperScissors

struct GamesTab: View {
   
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink("Guess the flag") {
                        GuessTheFlagView(store: GuessTheFlagDomain.previewStore)
                    }
                    NavigationLink("Rock-Paper-Scissors") {
                        RockPaperScissorsView(store: RockPaperScissorsDomain.previewStore)
                    }
                }
            }
            .navigationTitle("Games")
        }
    }
}

struct GamesTab_Previews: PreviewProvider {
    static var previews: some View {
        GamesTab()
    }
}
