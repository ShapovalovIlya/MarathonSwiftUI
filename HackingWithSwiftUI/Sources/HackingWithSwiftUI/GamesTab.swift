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
import WordScramble
import MultiplicationTables

struct GamesTab: View {
   
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink("Guess the flag") {
                        GuessTheFlagView(store: GuessTheFlagDomain.previewStore)
                    }
                    NavigationLink("Rock-Paper-Scissors") {
                        RockPaperScissorsContentView(store: RockPaperScissorsDomain.previewStore)
                    }
                    NavigationLink("Word scramble") {
                        WordScrambleView(store: WordScrambleDomain.liveStore)
                    }
                    NavigationLink("Multiplication tables") {
                        MultiplicationTablesView()
                    }
                }
            }
            .navigationTitle("Games")
        }
    }
}

#Preview {
    GamesTab()
}
