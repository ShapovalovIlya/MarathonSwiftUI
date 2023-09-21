//
//  File.swift
//  
//
//  Created by Илья Шаповалов on 18.09.2023.
//

import Foundation
import Combine

public extension Optional {
    var throwingPublisher: AnyPublisher<Wrapped, Error> {
        switch self {
        case .none:
            return Fail(error: CocoaError(.fileNoSuchFile))
                .eraseToAnyPublisher()
            
        case .some(let wrapped):
            return Just(wrapped)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
