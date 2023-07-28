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
        public var userScore: Int
        public var errorTitle: String
        public var errorMessage: String
        public var showError: Bool
        
        public init(
            usedWords: [String] = .init(),
            rootWord: String = .init(),
            newWord: String = .init(),
            userScore: Int = .init(),
            errorTitle: String = .init(),
            errorMessage: String = .init(),
            showError: Bool = false
        ) {
            self.usedWords = usedWords
            self.rootWord = rootWord
            self.newWord = newWord
            self.userScore = userScore
            self.errorTitle = errorTitle
            self.errorMessage = errorMessage
            self.showError = showError
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
        case dismissAlert
        
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
            return Just(state.newWord)
                .map(lowercase)
                .map(trimInappropriateSymbols)
                .tryMap(checkAppropriate)
                .tryMap{ [rootWord = state.rootWord] in try check($0, equalsTo: rootWord) }
                .tryMap{ [usedWords = state.usedWords] in try checkOriginal($0, in: usedWords) }
                .tryMap{ [rootWord = state.rootWord] in try checkIsPossible($0, in: rootWord) }
                .tryMap(checkIsReal)
                .map(transformToAddWordSuccessAction)
                .mapError(WordError.map)
                .catch(catchToAddWordFailureAction)
                .eraseToAnyPublisher()
                      
        case let .addNewWordResult(.success(newWord)):
            state.userScore += newWord.count
            state.usedWords.insert(newWord, at: 0)
            state.newWord.removeAll(keepingCapacity: true)
            
        case let .addNewWordResult(.failure(error)):
            reduce(&state, with: error)
            
        case .dismissAlert:
            state.showError = false
            
        }
        return Empty().eraseToAnyPublisher()
    }
    
    //MARK: - Live Store
    public static let liveStore = Store(
        state: Self.State(),
        reducer: Self())
    
    //MARK: - Preview Stores
    static let previewStore = Store(
        state: Self.State(),
        reducer: Self(loadWords: {
            Just(["Testword"])
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        })
    )
    
    static let previewStoreAlertState = Store(
        state: Self.State(
            errorTitle: WordError.notOriginal.title,
            errorMessage: WordError.notOriginal.message,
            showError: true
        ),
        reducer: Self())
}

//MARK: - Transformers
private extension WordScrambleDomain {
    func transformToSuccessAction(_ words: [String]) -> Action {
        .loadWordsResponse(.success(words))
    }
    
    func transformToAddWordSuccessAction(_ newWord: String) -> Action {
        .addNewWordResult(.success(newWord))
    }
}

//MARK: - Catchers
private extension WordScrambleDomain {
    func catchToFailureAction(_ error: Error) -> Just<Action> {
        Just(.loadWordsResponse(.failure(error)))
    }
    
    func catchToAddWordFailureAction(_ error: WordError) -> Just<Action> {
        Just(.addNewWordResult(.failure(error)))
    }
}

//MARK: - Checkers
private extension WordScrambleDomain {
    func checkAppropriate(_ newWord: String) throws -> String {
        guard !newWord.isEmpty,
              newWord.count > 2
        else {
            throw WordError.inappropriate
        }
        return newWord
    }
    
    func checkOriginal(_ newWord: String, in collection: [String]) throws -> String {
        guard !collection.contains(newWord) else {
            throw WordError.notOriginal
        }
        return newWord
    }
    
    func checkIsPossible(_ newWord: String, in rootWord: String) throws -> String {
        guard isPossible(newWord, in: rootWord) else {
            throw WordError.notPossible
        }
        return newWord
    }
    
    func checkIsReal(_ newWord: String) throws -> String {
        guard isReal(newWord) else {
            throw WordError.notReal
        }
        return newWord
    }
    
    func check(_ newWord: String, equalsTo rootWord: String) throws -> String {
        guard newWord != rootWord else {
            throw WordError.equalsToRootWord
        }
        return newWord
    }
}

//MARK: - Helpers
private extension WordScrambleDomain {
    func lowercase(_ string: String) -> String {
        string.lowercased()
    }
    
    func trimInappropriateSymbols(_ word: String) -> String {
        word.trimmingCharacters(in: .whitespacesAndNewlines)
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
    
    func reduce(_ state: inout State, with error: WordError) {
        state.errorTitle = error.title
        state.errorMessage = error.message
        state.showError = true
    }
}

extension WordScrambleDomain {
    //MARK: - Word Error
    public enum WordError: Error, Equatable, LocalizedError {
        case notOriginal
        case notPossible
        case notReal
        case inappropriate
        case equalsToRootWord
        case other(Error)
        
        public var title: String {
            switch self {
            case .notOriginal: return "Word used already"
            case .notPossible: return "Word not possible"
            case .notReal: return "Word not recognized"
            case .inappropriate: return "Word is inappropriate"
            case .equalsToRootWord: return "This is a root word"
            case .other: return "Unknown error."
            }
        }
        
        public var message: String {
            switch self {
            case .notOriginal: return "Be more original"
            case .notPossible: return "You can't spell that word from 'root word'!"
            case .notReal: return "You can't just make them up, you know!"
            case .inappropriate: return "You should use letters"
            case .equalsToRootWord: return "You can't use root word!"
            case let .other(error): return error.localizedDescription
            }
        }
        
        static func map(_ error: Error) -> WordError {
            error as? WordError ?? .other(error)
        }
        
        public static func == (lhs: WordScrambleDomain.WordError, rhs: WordScrambleDomain.WordError) -> Bool {
            guard
                lhs.title == rhs.title,
                lhs.message == rhs.message
            else {
                return false
            }
            return true
        }
    }
}
