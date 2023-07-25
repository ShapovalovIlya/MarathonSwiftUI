//
//  WordScrambleDomain.swift
//  
//
//  Created by Илья Шаповалов on 24.07.2023.
//

import Foundation
import Combine
import SwiftUDF

public struct WordScrambleDomain: ReducerDomain {
    //MARK: - State
    public struct State {
        public var usedWords: [String]
        public var rootWord: String
        public var newWord: String
        
        public init(
            usedWords: [String] = .init(),
            rootWord: String = .init(),
            newWord: String = .init()
        ) {
            self.usedWords = usedWords
            self.rootWord = rootWord
            self.newWord = newWord
        }
    }
    
    //MARK: - Action
    public enum Action: Equatable {
        case setNewWord(String)
        case addNewWord
    }
    
    //MARK: - init(_:)
    public init() {}
    
    //MARK: - Reducer
    public func reduce(_ state: inout State, action: Action) -> AnyPublisher<Action, Never> {
        switch action {
        case let .setNewWord(newWord):
            state.newWord = newWord
            
        case .addNewWord:
            let answer = state.newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            guard !answer.isEmpty else {
                break
            }
            state.usedWords.insert(answer, at: 0)
            state.newWord.removeAll(keepingCapacity: true)
        }
        return Empty().eraseToAnyPublisher()
    }
    
    //MARK: - Preview Store
    public static let previewStore = Store(
        state: Self.State(),
        reducer: Self())
}

private extension WordScrambleDomain {}
