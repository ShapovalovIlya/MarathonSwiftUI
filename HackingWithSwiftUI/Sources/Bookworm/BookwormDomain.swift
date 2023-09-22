//
//  BookwormDomain.swift
//
//
//  Created by Илья Шаповалов on 22.09.2023.
//

import Foundation
import SwiftUDF
import Shared
import AppDependencies
import Combine

public struct BookwormDomain: ReducerDomain {
    //MARK: - State
    public struct State: Equatable {
        public var students: [Student]
        
        public init(
            students: [Student] = .init()
        ) {
            self.students = students
        }
    }
    
    //MARK: - Action
    public enum Action: Equatable {
        
    }
    
    //MARK: - Dependencies
    private let storage: BookwormStorage
    
    //MARK: - init(_:)
    public init(storage: BookwormStorage = .live) {
        self.storage = storage
    }
    
    //MARK: - Reducer
    public func reduce(_ state: inout State, action: Action) -> AnyPublisher<Action, Never> {
        
        return empty()
    }
    
    //MARK: - Preview Store
    static let previewStore = Store(
        state: Self.State(),
        reducer: Self()
    )
    
    //MARK: - Live Store
    public static let liveStore = Store(
        state: Self.State(),
        reducer: Self()
    )
}
