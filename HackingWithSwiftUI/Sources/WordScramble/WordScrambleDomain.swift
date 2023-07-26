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
        case addNewWordResult(Result<String, WordError>)
        
        public static func == (lhs: WordScrambleDomain.Action, rhs: WordScrambleDomain.Action) -> Bool {
            String(describing: lhs) == String(describing: rhs)
        }
    }
    
    //MARK: - Word Error
    public enum WordError: Error, Equatable, LocalizedError {
        case notOriginal
        case notPossible
        case notReal
        case inappropriate
        
        var title: String {
            switch self {
            case .notOriginal: return "Word used already"
            case .notPossible: return "Word not possible"
            case .notReal: return "Word not recognized"
            case .inappropriate: return "Word is inappropriate"
            }
        }
        
        var message: String {
            switch self {
            case .notOriginal: return "Be more original"
            case .notPossible: return "You can't spell that word from 'rootWord'!"
            case .notReal: return "You can't just make them up, you know!"
            case .inappropriate: return "You should use letters"
            }
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
            return check(state.newWord, in: state)
            
//            state.usedWords.insert(state.newWord, at: 0)
//            state.newWord.removeAll(keepingCapacity: true)
//            
        case let .addNewWordResult(.success(newWord)):
            break
            
        case let .addNewWordResult(.failure(error)):
            break
            
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
    
    func isOriginal(_ word: String, in collection: [String]) -> Bool {
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
    
    func check(_ newWord: String, in state: State) -> AnyPublisher<Action, Never> {
        let newWord = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !newWord.isEmpty else {
            return Just(.addNewWordResult(.failure(.inappropriate))).eraseToAnyPublisher()
        }
        
        guard isOriginal(newWord, in: state.usedWords) else {
            return Just(.addNewWordResult(.failure(.notOriginal)))
                .eraseToAnyPublisher()
        }
        
        guard isPossible(newWord, in: state.rootWord) else {
            return Just(.addNewWordResult(.failure(.notPossible)))
                .eraseToAnyPublisher()
        }
        
        guard isReal(newWord) else {
            return Just(.addNewWordResult(.failure(.notReal))).eraseToAnyPublisher()
        }
        
        return Just(.addNewWordResult(.success(newWord))).eraseToAnyPublisher()
    }
}
