//
//  BookwormStorage.swift
//
//
//  Created by Илья Шаповалов on 22.09.2023.
//

import Foundation
import AppDependencies
import Combine
import OSLog
import Shared

public struct BookwormStorage {
    //MARK: - Public properties
    public var fetchStudents: () -> AnyPublisher<[Student], Error>
    
    //MARK: - init(_:)
    public init(
        fetchStudents: @escaping () -> AnyPublisher<[Student], Error>
    ) {
        self.fetchStudents = fetchStudents
    }
    
    //MARK: - Live
    public static var live: BookwormStorage {
        let storage = BookwormProvider(logger: Logger.system)
        
        return .init(
            fetchStudents: storage.fetchStudents
        )
    }
    
    //MARK: - Test
    public static var successStorage: BookwormStorage {
        let student = Student()
        student.name = "Baz"
       
        return .init(
            fetchStudents: {
                Just([student])
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
        )
    }
    
}
