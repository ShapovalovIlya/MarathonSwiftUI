//
//  Atomic.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 07.08.2023.
//

import Foundation

@propertyWrapper
public struct Atomic<T> {
    private let lock = NSLock()
    private var value: T
    
    public var wrappedValue: T {
        get { value }
        set {
            lock.lock()
            value = newValue
            lock.unlock()
        }
    }
    
    public init(value: T) {
        self.value = value
    }
}
