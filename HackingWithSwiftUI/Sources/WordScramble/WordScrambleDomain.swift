//
//  WordScrambleDomain.swift
//  
//
//  Created by Илья Шаповалов on 24.07.2023.
//

import Foundation
import Combine
import SwiftUDF
import AppDependencies

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
        case startGame
        case loadWordsRequest
        case loadWordsResponse(Result<[String], Error>)
        case setNewWord(String)
        case addNewWord
        
        public static func == (lhs: WordScrambleDomain.Action, rhs: WordScrambleDomain.Action) -> Bool {
            String(describing: lhs) == String(describing: rhs)
        }
    }
    
    //MARK: - Dependencies
    private var loadWords: () -> AnyPublisher<[String], Error>
    private var isReal: (String) -> Bool
    
    //MARK: - init(_:)
    public init(
        loadWords: @escaping () -> AnyPublisher<[String], Error> = FileManager.loadResources,
        isReal: @escaping (String) -> Bool = TextChecker.isReal
    ) {
        self.loadWords = loadWords
        self.isReal = isReal
    }
    
    //MARK: - Reducer
    public func reduce(_ state: inout State, action: Action) -> AnyPublisher<Action, Never> {
        switch action {
        case .startGame:
            return Just(.loadWordsRequest).eraseToAnyPublisher()
            
        case .loadWordsRequest:
            return loadWords()
                .map(transformToSuccessAction)
                .catch(catchToFailureAction)
                .eraseToAnyPublisher()
            
        case let .loadWordsResponse(.success(words)):
            state.rootWord = words.randomElement() ?? "silkworm"
            
        case let .loadWordsResponse(.failure(error)):
            print(error)
            
        case let .setNewWord(newWord):
            state.newWord = newWord
            
        case .addNewWord:
            let answer = state.newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            guard
                !answer.isEmpty,
                isOrigin(answer, in: state.usedWords),
                isPossible(answer, in: state.rootWord),
                isReal(answer)
            else {
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

private extension WordScrambleDomain {
    func transformToSuccessAction(_ words: [String]) -> Action {
        .loadWordsResponse(.success(words))
    }
    
    func catchToFailureAction(_ error: Error) -> Just<Action> {
        .init(.loadWordsResponse(.failure(error)))
    }
    
    func isOrigin(_ word: String, in collection: [String]) -> Bool {
        !collection.contains(word)
    }
    
    func isPossible(_ word: String, in rootWord: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            guard let possible = tempWord.firstIndex(of: letter) else {
                return false
            }
            tempWord.remove(at: possible)
        }
        return true
    }
}
