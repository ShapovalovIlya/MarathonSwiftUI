//
//  WordScrambleView.swift
//  
//
//  Created by Илья Шаповалов on 24.07.2023.
//

import SwiftUI
import SwiftUDF

public struct WordScrambleView: View {
    @ObservedObject private var store: StoreOf<WordScrambleDomain>
    
    public var body: some View {
        List {
            Section {
                TextField(
                    "Enter your word",
                    text: Binding(
                        get: { store.newWord },
                        set: { store.send(.setNewWord($0)) })
                )
                .textInputAutocapitalization(.never)
                .onSubmit { store.send(.addNewWord) }
            }
            
            Section {
                ForEach(store.usedWords, id: \.self, content: WordRow.init)
            }
        }
        .navigationTitle(store.rootWord)
        .listStyle(.grouped)
        .onAppear{ store.send(.startGame) }
    }
    
    public init(store: StoreOf<WordScrambleDomain>) {
        self.store = store
    }
    
}

#Preview("Common state") {
    NavigationStack {
        WordScrambleView(store: WordScrambleDomain.previewStore)
    }
}
